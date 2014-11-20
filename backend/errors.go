package backend

import (
	"fmt"

	"github.com/Manbeardo/eventreporter"
)

type ErrorPlayerAlreadyExists struct {
	Old eventreporter.Player
	New eventreporter.Player
}

func (e ErrorPlayerAlreadyExists) Error() string {
	return fmt.Sprintf("Could not create player: %+v\n\tPlayer with id '%v' already exists: %+v", e.New, e.New.Id, e.Old)
}
