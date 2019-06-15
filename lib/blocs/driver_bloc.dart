import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/models/location_model.dart';
import 'package:owner/repositories/driver/driver_repository.dart';
import 'package:owner/repositories/location/location_repository.dart';
import 'package:owner/utils/Utills.dart';

class DriverBloc{
  var _driverRepository = DriverRepository();
  var _locationRepository = LocationRepository();

  final _locationsSubject = PublishSubject<List<LocationModel>>();
  final _distanceSubject = PublishSubject<double>();
  final _speedSubject = PublishSubject<double>();
  final _durationSubject = PublishSubject<String>();
  final _dateSubject = PublishSubject<DateTime>();
  final _driverSubject = PublishSubject<DriverModel>();

  Stream<List<LocationModel>> get locationsStream => 
  _locationsSubject.stream.asBroadcastStream();

  Stream<double> get distanceStream => _distanceSubject.stream.asBroadcastStream();
  Stream<double> get speedStream => _speedSubject.stream.asBroadcastStream();
  Stream<String> get durationStream => _durationSubject.stream.asBroadcastStream();
  Stream<DateTime> get dateStream => _dateSubject.stream;
  Stream<DriverModel> get driverStream => _driverSubject.stream;



  DriverBloc(){
    changeDate(DateTime.now());

    Observable.combineLatest2(dateStream, driverStream, (DateTime date, DriverModel driver){
      var map = Map<String, dynamic>();
      map['date'] = date;
      map['driver'] = driver;
      return map;
    }).shareValue().listen((map){
      _locationRepository.getDateList(map['date'], map['driver']).listen((QuerySnapshot snapshot){
        _init(snapshot);
      });
    });
    
  }

  driverChange(DriverModel driver){
    _driverSubject.sink.add(driver);
  }


  changeDate(DateTime time){
    _dateSubject.sink.add(time);
  }

  updateDriverInfo(DriverModel model){
    _driverRepository.update(null, model, model);
  }

  _init(QuerySnapshot snapshot){
    var locations = snapshot.documents.map((documentSnapshot) => LocationModel(documentSnapshot.data['location'])).toList(growable: true);
    locations.sort((a, b) => DateTime.parse(a.timestamp).millisecondsSinceEpoch.compareTo(DateTime.parse(b.timestamp).millisecondsSinceEpoch));
      locations.forEach((l){
        if(l.coords.speed < 0){
          l.coords.speed = 0;
        }
      });

      var distance = 0.0;
      var speed = 0.0;
      var length = locations.length;
      if(length > 2){
        for (int i = 0;i < length - 1; i++) { 
          distance += Utils.getDistanceBetween(locations[i].coords, locations[i+1].coords);
          speed +=  locations[i].coords.speed;
        }
      }

      if(locations.length != 0)
        speed += locations.last.coords.speed;

      if(locations.length != 0){
        var startTime = DateTime.parse(locations.first.timestamp);
        var endTime = DateTime.parse(locations.last.timestamp);

        Duration dur =  endTime.difference(startTime);
        String differenceInYears = (dur.inHours).floor().toString();
        
        _durationSubject.sink.add(differenceInYears);
      }
      _locationsSubject.sink.add(locations);
      _distanceSubject.sink.add(distance);
      _speedSubject.sink.add(speed/length);
  }
}