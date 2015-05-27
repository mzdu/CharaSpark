myApp.controller('HomeCtrl', function($scope, CharityService, $state, lodash, $localStorage, $ionicLoading, WishService, DonationService, ResponseService) {
  

$scope.wish = {

}

$scope.donation = {
  amount: null,
}

$scope.charity = {
  selectedCharity: '',
}


// populates variables needed by page

  //populates charities 
var promise = CharityService.all();
  promise.then(function(chars, err) {
    // returns a list of users
    if(!err){
      // console.log('list is: ', chars);
      $scope.charities = lodash.sortBy(chars, 'name');; // first Restangular obj in list: { id: 123 }
      console.log('charities population', $scope.charities);
    }
    else {
      console.log('error is: ', err);
    }

  }); // end of promise 



  //populates wishes
var promise = WishService.findWishesFromUser();
    promise.then(function(wishes, err) {
    // returns a list of users
    if(!err){
      // console.log('list is: ', wishes);
      $scope.wishes = wishes;
      console.log('wishes ', $scope.wishes);
    }
    else {
      console.log('error is: ', err);
    }

  }); // end of promise 


  $scope.goToDetails = function(wish){
	// save wish object to the localStorage for the next page using
//	alert('dd');
    $localStorage.wish = wish;
//    console.log('details of localStorage', $localStorage);
    $state.go('tab.mywishdescription');

  }

  //get geo location 
    var geoLoc = [];
    navigator.geolocation
      .getCurrentPosition(function(pos) {
              geoLoc.push(pos.coords.latitude);
              geoLoc.push(pos.coords.longitude);
              console.log('geoLoc is: ', geoLoc);
          });

  $scope.MakeAWish = function(){

    
      $scope.wish.location = geoLoc;
      $scope.donation._charity = $scope.wish._charity;

  		console.log('the wish is: ', $scope.wish);

  				var promise = WishService.add($scope.wish);
          
          promise.then(function(wishResult, wishErr) {
                                      
            if(!wishErr){
                    console.log('wish successfully added: ', wish);
                //add the donation
                //associates the wishID with donation
                $scope.donation._wish = wishResult._id;
                promise = DonationService.add($scope.donation);

                promise.then(function(donationResult, donationErr) {
                    if(!donationErr){
                      console.log('donation successfully added: ', donationResult);
                    } else {
                      console.log('error adding donation: ', donationErr)
                    }
                }, function (response){
                  console.log('reponse is: ', response);
                  $state.go('login'); 
                   // ResponseService.handleResponse(response, $state); 
                });

  		    	}
  		    	else {
  		    		// $state.go('tab.tree');
              console.log('error adding wish: ', wishErr)
  		    	}
  		       
  		    }, function (response){
            console.log('reponse is: ', response);
              $state.go('login');
                   // ResponseService.handleResponse(response, $state); 
                }); //end of promise then
	}

	

  }) //end of controller