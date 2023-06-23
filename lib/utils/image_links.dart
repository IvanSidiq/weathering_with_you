//Taking them pictures from PEXEL credit by them
//For now saving them manually here coz it would take long time to randomize image by their API

class ImageLinks {}

String linkById({required weatherCode, required bool night}) {
  String id = '';
  switch (weatherCode) {
    case >= 200 && < 300:
      //Thunderstorm
      id = night ? '258173' : '4610233';
      break;
    case >= 300 && < 400:
      //Drizzle
      id = night ? '16262769' : '1089318';
      break;
    case >= 500 && < 600:
      //Rain
      id = night ? '1686961' : '1211839';
      break;
    case >= 600 && < 700:
      //Snow
      id = night ? '3333923' : '947937';
      break;
    case >= 700 && < 800:
      //Atmosphere
      id = night ? '939807' : '14529210';
      break;
    case 800:
      //Clear
      id = night ? '4327218' : '789152';
      break;
    case > 800 && < 900:
      //Cloud
      id = night ? '4203094' : '1285625';
      break;
    default:
      id = night ? '4327218' : '789152';
  }
  return 'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';
}
