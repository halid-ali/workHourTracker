import 'package:work_hour_tracker/data/dao/option_dao.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';

class OptionRepository {
  final optionDao = OptionDao();

  Future<List<Option>> getOptions() => optionDao.getOptions();

  Future<Option> getOption(int id) => optionDao.getOption(id);

  Future addOption(Option option) => optionDao.addOption(option);

  Future updateOption(Option option) => optionDao.updateOption(option);

  Future deleteOption(int id) => optionDao.deleteOption(id);
}
