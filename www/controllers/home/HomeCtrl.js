myApp.controller('HomeCtrl', function($scope, 
                                      CharityService, 
                                      $state, 
                                      lodash, 
                                      $localStorage, 
                                      $ionicLoading, 
                                      WishService, 
                                      DonationService, 
                                      StorageService, 
                                      PromiseService,
                                      LocationService) {

console.log('in home ctrl');
//---------- get current user info ---------------

var user = StorageService.getCurrentUser();

if(user){

  // ---------- declare variables needed by $scope ---------------

  $scope.wish = {}

  $scope.donation = {
    amount: null,
  }

  $scope.charity = {
    selectedCharity: '',
  }


  // ---------- populates variables needed by page ---------------


  //populates charities for dropdown
  var charityPromise = CharityService.all();

  PromiseService.getData(charityPromise,  function(data){
    if(data){
      $scope.charities = lodash.sortBy(data, 'name');
    }
  });

  //populates the user's wishes

  var wishRPromise = WishService.findWishesFromUser(user.user._id);
  PromiseService.getData(wishRPromise, function(data){
    if(data){
      console.log('wish data is: ', data);
      $scope.wishes = lodash.sortBy(data, 'createdDate').reverse();
    }
  });

  //get geo location 
  var geoLoc = [];
  LocationService.getCurrentLocation(function(location){
    if(location){
      geoLoc = location;
    }
  });
     

    $scope.MakeAWish = function(){
        $scope.wish.location = geoLoc;
        console.log('geo loc is: ', geoLoc);
        $scope.donation._charity = $scope.wish._charity;

    		console.log('the wish is: ', $scope.wish);

  			var wishCPromise = WishService.add($scope.wish);
        
        PromiseService.getData(wishCPromise, function(wishData){
          if(wishData){
            console.log('wish successfully created');
            console.log('wish id is: ', wishData._id);
            //associated the wish id to the donation
            $scope.donation._wish = wishData._id;

            //add the donation
            var donationPromise = DonationService.add($scope.donation);
            PromiseService.getData(donationPromise, function(donationData){
              if(donationData){

                console.log('donation successfully created');
                console.log('donation id is: ', donationData._id);
                //update the wish with the donationID
                wishData._donation = donationData._id;
                var wishUPromise = WishService.update(wishData);
                PromiseService.getData(wishUPromise, function(wishData2){
                  if(wishData2){
                    console.log('the wish has been updated.');
                    $state.go('tab.tree',{'donationID': donationData._id});
                  }
                }); //end of PromiseService
              } //end of if(donationData)
            });
        }
        });

        
  	} //end of make a wish


    //transitions to the wish details page
    $scope.goToDetails = function(wish){
    // save wish object to the localStorage for the next page using
      // $localStorage.wish = wish;
      $state.go('tab.wishDetails', { 'wishID': wish._id});
    }


	} //end of if(user)

}) //end of controller