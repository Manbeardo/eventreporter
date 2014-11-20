(function() {
    app = angular.module('index', ['ui.router']);

    app.directive('navbar', function() {
        return {
            restrict: 'E',
            templateUrl: '/static/tpl/navbar.tpl'
        };
    });

    app.directive('sidebar', function() {
        return {
            restrict: 'E',
            templateUrl: '/static/tpl/sidebar.tpl'
        };
    });

    app.controller('PlayersController', ['$http',
        function($http) {
            playersCtrl = this;
            this.players = [];
            this.newPlayer = {};
            this.listAll = function() {
                $http.get('/backend/players/list').success(function(data) {
                    playersCtrl.players = data;
                });
            };
            this.search = function(query) {
                $http.get('/backend/players/search?' + $.param({"Query": query})).success(function(data){
                    playersCtrl.players = data;
                });
            };
            this.createPlayer = function() {
                $http.post('/backend/players/create?' + $.param(playersCtrl.newPlayer))
                    .success(function(data){
                        playersCtrl.players.push(data[0]);
                    })
                    .error(function(data){ 
                        alert(data);
                    });
            }
        }
    ]);

    app.config(function($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.otherwise("/welcome");

        $stateProvider.state('welcome', {
            url: "/welcome",
            templateUrl: "/static/tpl/welcome.tpl"
        });
        $stateProvider.state('players', {
            url: "/players",
            templateUrl: "/static/tpl/players.tpl",
            controller: "PlayersController as playersCtrl"
        });
        $stateProvider.state('events', {
            url: "/events",
            templateUrl: "/static/tpl/events.tpl"
        });
    });
})();