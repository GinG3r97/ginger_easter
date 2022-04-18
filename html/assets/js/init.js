$(document).ready(function(){
  // LUA listener
  // $('#id-card').show();
  // $ ('#id-card').css('background', 'url(assets/img/banner.png)');
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'openGingerEaster') {
      $('#id-card').show();
      $ ('#id-card').css('background', 'url(assets/img/banner.png)');
    }else if (event.data.action == 'closeGingerEaster') {
      $('#id-card').hide();
    }
  });
  // window.addEventListener('message', function( event ) {
  //   if (event.data.action == 'openGingerCardUI') {
  //     var gender = "Male";
  //     var userData = event.data.array['playerData'][0];
  //     var cardType = event.data.array['playerID'];
  
  //     var today = new Date();
  //     var birthDate = new Date(userData.dob);
  //     var age = today.getFullYear() - birthDate.getFullYear();
  //     var m = today.getMonth() - birthDate.getMonth();
  //     if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
  //         age--;
  //     }
  //     if (userData.gender == 1) {
  //       gender = "Female"
  //     }

  //     $('#firstName').text(userData.first_name);
  //     $('#lastName').text(userData.last_name);
  //     $('#dob').text(userData.dob);
  //     $('#sex').text(userData.gender == 1 ? gender = "Female" : gender);
  //     $('#age').text(age);
  //     $('#signature').text(userData.last_name);

  //     if (cardType == "citizenCard") {
  //       $('#id-card').css('background', 'url(assets/images/citizenID.png)');
  //     }else if (cardType == "driverCard"){
  //       $('#id-card').css('background', 'url(assets/images/driverID.png)');
  //     }
  //     else if (cardType == "weaponCard"){
  //       $ ('#id-card').css('background', 'url(assets/images/weaponID.png)');
  //     }
  //     $('#id-card').show();

    // } else if (event.data.action == 'closeGingerCardUI') {
    //   $('#name').text('');
    //   $('#dob').text('');
    //   $('#height').text('');
    //   $('#signature').text('');
    //   $('#sex').text('');
    //   $('#id-card').hide();
    //   $('#licenses').html('');
    // }
  // });
});
