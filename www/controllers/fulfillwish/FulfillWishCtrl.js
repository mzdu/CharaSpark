(function() {
    'use strict';
    myApp.controller('FulfillWishCtrl', function($scope,
        $state,
        WishService,
        $localStorage,
        lodash,
        PromiseService,
        LocationService) {
        //populates the location
        var locPromise = LocationService.getCurrentLocation();
        PromiseService.getData(locPromise, function(data) {
            if (data) {
                var promise = WishService.all({
                    location: data,
                    radius: 400
                });

                PromiseService.getData(promise, function(data) {
                    if (data) {
                        console.log('successful! ', data);
                        $scope.wishes = lodash.sortBy(data, 'createdDate').reverse();
                    }
                });
            }
        });

        $scope.goToDetails = function(wish) {
            //console.log('go to detail of wish ', wish._id);
            $state.go('tab.fulfillWishDetails', {
                'wishID': wish._id
            });
        };

        $scope.doRefresh = function() {
            var locPromise = LocationService.getCurrentLocation();
            PromiseService.getData(locPromise, function(data) {
                if (data) {
                    var promise = WishService.all({
                        location: data,
                        radius: 400
                    });

                    PromiseService.getData(promise, function(data) {
                        if (data) {
                            console.log('successful! ', data);
                            $scope.wishes = lodash.sortBy(data, 'createdDate').reverse();
                        }
                    });
                }
            });
        };

    });
})();
