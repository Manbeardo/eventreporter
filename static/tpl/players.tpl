<h2>Players</h2>
<table class="table table-striped">
    <thead>
        <tr>
            <th>Name</th>
            <th>Id</th>
        </tr>
    </thead>
    <tbody>
        <tr ng-repeat="player in playersCtrl.players">
            <td>{{player.Name}}</td>
            <td>{{player.Id}}</td>
        </tr>
    </tbody>
</table>
<div>
    <button class="btn" ng-click="playersCtrl.listAll()">List All Players</button>
</div>
<div>
    <form name="playerCreator">
        <fieldset class="form-group">
            <input class="form-control" type="text" placeholder="Name" title="Name"/>
            <input class="form-control" type="text" placeholder="Id" title="Id"/>
            <input class="btn" type="submit" value="Create Player"/>
        </fieldset>
    </form>
</div>