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
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          child: ListView(
            children: [
              _buildDescriptionField(),
              _buildAttachmentView(),
              Row(
                children: [
                  _buildStatusField(),
                  Spacer(),
                  _buildAttachmentButton(),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
                child: const Text('Notify'),
              ),
              _buildNotifyField(),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
      child: Consumer<TodoWriteModel>(
        builder: (context, writeModel, child) {
          return TextFormField(
            initialValue: writeModel.description,
            decoration: InputDecoration(
              hintText: 'Add a task',
            ),
            onChanged: (String value) => writeModel.setDescription(value),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Consumer<TodoWriteModel>(
        builder: (context, writeModel, child) {
          return ActionImage(
            src: writeModel.preview,
            onTapped: () => writeModel.setPreview(''),
          );
        },
      ),
    );
  }

  Widget _buildStatusField() {
    return Consumer<TodoWriteModel>(
      builder: (context, writeModel, child) {
        return TextButton.icon(
          icon: writeModel.isDone
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
          onPressed: () => writeModel.toggleStatus(),
        );
      },
    );
  }

  Widget _buildAttachmentButton() {
    final picker = ImagePicker();
    PickedFile picked;

    return Consumer<TodoWriteModel>(
      builder: (context, writeModel, child) {
        return IconButton(
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
                        picked = await picker.getImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          writeModel.setPreview(picked.path);
                        }
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Take photo'),
                      onTap: () async {
                        picked = await picker.getImage(
                          source: ImageSource.camera,
                        );
                        if (picked != null) {
                          writeModel.setPreview(picked.path);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotifyField() {
    return Consumer<TodoWriteModel>(
      builder: (context, writeModel, child) {
        return Wrap(
          direction: Axis.horizontal,
          children: [
            LabeledRadio(
              label: '5 mins',
              value: 5,
              groupValue: writeModel.notify,
              onChanged: (int value) => writeModel.setNotify(value),
            ),
            LabeledRadio(
              label: '10 mins',
              value: 10,
              groupValue: writeModel.notify,
              onChanged: (int value) => writeModel.setNotify(value),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Consumer2<TodoWriteModel, TodoStoreModel>(
      builder: (context, writeModel, storeModel, child) {
        return Padding(
          padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
          child: ElevatedButton(
            child: Text('Save'),
            onPressed: writeModel.isValid
                ? () async {
                    await storeModel.repository.write(writeModel.data);
                    storeModel.refresh();
                    Navigator.pop(context);
                  }
                : null,
          ),
        );
      },
    );
  }
}
