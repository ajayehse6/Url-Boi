import 'package:get_it/get_it.dart';
import 'package:url_boi/services/dynamic_links_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(()=>DynamicLinksService());
}