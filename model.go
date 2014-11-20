package eventreporter

import (
	"fmt"
	"math"
	"math/rand"
	"sort"
	"time"
)

type EventId string
type RoundId string
type MatchId string

type Player struct {
	Name string `checks:"NotEmpty"`
	Id   string `checks:"NotEmpty"`
}

type PlayerSlice []Player

func (a PlayerSlice) Len() int           { return len(a) }
func (a PlayerSlice) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a PlayerSlice) Less(i, j int) bool { return false }

type ById struct {
	PlayerSlice
}

func (a *ById) Less(i, j int) bool { return a.PlayerSlice[i].Id < a.PlayerSlice[j].Id }

type Match struct {
	Player1  Player
	Player2  Player
	Table    int
	Record   Record
	Complete bool
}

func (m Match) Points(p Player) (int, error) {
	var winner *Player
	if m.Record.Win > m.Record.Lose {
		winner = &m.Player1
	} else if m.Record.Win < m.Record.Lose {
		winner = &m.Player2
	}
	if p == m.Player1 || p == m.Player2 {
		if winner == nil {
			return 1, nil
		} else if p == *winner {
			return 3, nil
		} else {
			return 0, nil
		}
	} else {
		return 0, fmt.Errorf("Player %+v did not participate in match %+v", p, m)
	}
}

func (m Match) gamePoints(p Player) int {
	if p == m.Player1 {
		return (m.Record.Win * 3) + m.Record.Draw
	} else if p == m.Player2 {
		return (m.Record.Lose * 3) + m.Record.Draw
	} else {
		panic(fmt.Errorf("Player %+v did not participate in match %+v", p, m))
	}
}

func (m Match) panicPoints(p Player) int {
	points, err := m.Points(p)
	if err != nil {
		panic(err)
	}
	return points
}

type Record struct {
	Win  int
	Draw int
	Lose int
}

func (r Record) GamesPlayed() int {
	return r.Win + r.Draw + r.Lose
}

type Round struct {
	Matches []Match
	Active  bool
}

func (r *Round) Len() int           { return len(r.Matches) }
func (r *Round) Swap(i, j int)      { r.Matches[i], r.Matches[j] = r.Matches[j], r.Matches[i] }
func (r *Round) Less(i, j int) bool { return r.Matches[i].Table < r.Matches[j].Table }

type ByMatchPoints struct {
	MatchPoints map[Player]int
	PlayerSlice
}

func NewByMatchPoints(event Event) ByMatchPoints {
	bmp := ByMatchPoints{MatchPoints: event.MatchPoints()}
	for p, _ := range event.ActivePlayers {
		bmp.PlayerSlice = append(bmp.PlayerSlice, p)
	}
	return bmp
}

func (a *ByMatchPoints) Less(i, j int) bool {
	return a.MatchPoints[a.PlayerSlice[i]] < a.MatchPoints[a.PlayerSlice[j]]
}

type ByTieBreakers struct {
	MatchPoints   map[Player]int
	MatchWinRates map[Player]float64
	GameWinRates  map[Player]float64
	PlayerSlice
}

func NewByTieBreakers(event Event) ByTieBreakers {
	btb := ByTieBreakers{
		MatchPoints:   event.MatchPoints(),
		MatchWinRates: event.MatchWinRates(),
		GameWinRates:  event.GameWinRates(),
	}
	for p, _ := range event.ActivePlayers {
		btb.PlayerSlice = append(btb.PlayerSlice, p)
	}
	return btb
}

func (a *ByTieBreakers) Less(i, j int) bool {
	p1, p2 := a.PlayerSlice[i], a.PlayerSlice[j]
	// Match Points
	mp1, mp2 := a.MatchPoints[p1], a.MatchPoints[p2]
	if mp1 != mp2 {
		return mp1 < mp2
	}
	// Opponent Match Win Percentage
	omw1, omw2 := a.MatchWinRates[p2], a.MatchWinRates[p1]
	if omw1 != omw2 {
		return omw1 < omw2
	}
	// Game Win Percentage
	gwp1, gwp2 := a.GameWinRates[p1], a.GameWinRates[p2]
	if gwp1 != gwp2 {
		return gwp1 < gwp2
	}
	// Opponent Game Win Percentage
	ogp1, ogp2 := a.GameWinRates[p2], a.GameWinRates[p1]
	return ogp1 < ogp2
}

type Event struct {
	Rounds        []Round
	ActivePlayers map[Player]interface{}
	Title         string
	Active        bool
}

func NewEvent() *Event {
	return &Event{
		ActivePlayers: make(map[Player]interface{}),
	}
}

func (e Event) MatchPoints() map[Player]int {
	matchPoints := make(map[Player]int)
	for _, round := range e.Rounds {
		for _, match := range round.Matches {
			p1, p2 := match.Player1, match.Player2
			matchPoints[p1] = matchPoints[p1] + match.panicPoints(p1)
			matchPoints[p2] = matchPoints[p2] + match.panicPoints(p2)
		}
	}
	return matchPoints
}

func (e Event) MatchWinRates() map[Player]float64 {
	matchPoints := e.MatchPoints()
	roundsPlayed := make(map[Player]int)
	for _, round := range e.Rounds {
		for _, match := range round.Matches {
			p1, p2 := match.Player1, match.Player2
			roundsPlayed[p1] = roundsPlayed[p1] + 1
			roundsPlayed[p2] = roundsPlayed[p2] + 1
		}
	}
	winRates := make(map[Player]float64)
	for player, Rounds := range roundsPlayed {
		winRates[player] = math.Min(0.33, float64(matchPoints[player])/(float64(Rounds)*3.0))
	}
	return winRates
}

func (e Event) GameWinRates() map[Player]float64 {
	gamePoints := make(map[Player]int)
	gamesPlayed := make(map[Player]int)
	for _, round := range e.Rounds {
		for _, match := range round.Matches {
			p1, p2 := match.Player1, match.Player2
			gamePoints[p1] = gamePoints[p1] + match.gamePoints(p1)
			gamePoints[p2] = gamePoints[p2] + match.gamePoints(p2)
			gamesPlayed[p1] = gamesPlayed[p1] + match.Record.GamesPlayed()
			gamesPlayed[p2] = gamesPlayed[p2] + match.Record.GamesPlayed()
		}
	}
	gameWinRates := make(map[Player]float64)
	for player, points := range gamePoints {
		gameWinRates[player] = float64(points) / (float64(gamesPlayed[player]) * 3.0)
	}
	return gameWinRates
}

func (e Event) GeneratePairings() Round {
	bmp := NewByMatchPoints(e)
	Shuffle(bmp.PlayerSlice)
	sort.Sort(&bmp)
	numMatches := int(math.Ceil(float64(len(bmp.PlayerSlice)) / 2))
	round := Round{Matches: make([]Match, numMatches)}
	for i := 0; i < numMatches; i++ {
		p1 := i * 2
		p2 := (i * 2) + 1
		match := Match{
			Player1: bmp.PlayerSlice[p1],
			Table:   i,
		}
		if p2 < len(bmp.PlayerSlice) {
			match.Player2 = bmp.PlayerSlice[p2]
		}
		round.Matches[i] = match
	}
	return round
}

func (e Event) FinalRankings() []Player {
	btb := NewByTieBreakers(e)
	Shuffle(btb.PlayerSlice)
	sort.Sort(&btb)
	return []Player(btb.PlayerSlice)
}

func Shuffle(data sort.Interface) {
	rand.Seed(time.Now().UnixNano())
	n := data.Len()
	for i := n - 1; i > 0; i-- {
		j := rand.Intn(i + 1)
		data.Swap(i, j)
	}
}
