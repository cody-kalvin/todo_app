import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_store_model.dart';
import 'package:todo_app/provider/todo_write_model.dart';
import 'package:todo_app/ui/common/action_image.dart';
import 'package:todo_app/ui/common/labeled_radio.dart';

class TodoWritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _writeModel = Provider.of<TodoWriteModel>(context);

    final _storeModel = Provider.of<TodoStoreModel>(context, listen: false);

    final _picker = ImagePicker();
    PickedFile _picked;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
                child: TextFormField(
                  initialValue: _writeModel.description,
                  decoration: InputDecoration(
                    hintText: 'Add a task',
                  ),
                  onChanged: (String value) =>
                      _writeModel.setDescription(value),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: ActionImage(
                  src: _writeModel.preview,
                  onTapped: () => _writeModel.setPreview(''),
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    icon: _writeModel.isDone
                        ? Icon(
                            Icons.check_box_outlined,
                            color: Theme.of(context).primaryColorDark,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.black54,
                          ),
                    label: Text(
                      'Mark as done',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                    onPressed: () => _writeModel.toggleStatus(),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.insert_photo_outlined),
                    color: Colors.grey.shade700,
                    splashColor: Colors.transparent,
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Container(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () async {
                                  _picked = await _picker.getImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (_picked != null) {
                                    _writeModel.setPreview(_picked.path);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Take photo'),
                                onTap: () async {
                                  _picked = await _picker.getImage(
                                    source: ImageSource.camera,
                                  );
                                  if (_picked != null) {
                                    _writeModel.setPreview(_picked.path);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
                child: Text(
                  'Notify',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  LabeledRadio(
                    label: '5 mins',
                    value: 5,
                    groupValue: _writeModel.notify,
                    onChanged: (int value) => _writeModel.setNotify(value),
                  ),
                  LabeledRadio(
                    label: '10 mins',
                    value: 10,
                    groupValue: _writeModel.notify,
                    onChanged: (int value) => _writeModel.setNotify(value),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
                child: ElevatedButton(
                  child: Text('Save'),
                  onPressed: _writeModel.isValid
                      ? () async {
                          await _storeModel.repository.write(_writeModel.data);
                          _storeModel.refresh();
                          Navigator.pop(context);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
