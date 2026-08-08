import 'package:flutter/cupertino.dart';
import 'package:luamris_ui/luamris_ui.dart';

class FieldsDemo extends StatefulWidget {
  const FieldsDemo({super.key});

  @override
  State<FieldsDemo> createState() => _FieldsDemoState();
}

class _FieldsDemoState extends State<FieldsDemo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '表单 McField',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _sectionTitle('Text 文本输入', m),
            const SizedBox(height: 10),
            McCard.elevated(
              child: Column(
                children: [
                  McField.text(
                    placeholder: '请输入用户名',
                    prefix: const Icon(CupertinoIcons.person, size: 18),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  McField.text(
                    placeholder: '请输入邮箱',
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(CupertinoIcons.mail, size: 18),
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 12),
                  const McField.text(
                    placeholder: '个人简介（选填）',
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _sectionTitle('Password 密码输入', m),
            const SizedBox(height: 10),
            McCard.elevated(
              child: Column(
                children: [
                  const McField.password(
                    placeholder: '请输入密码',
                  ),
                  const SizedBox(height: 12),
                  const McField.password(
                    placeholder: '请再次输入密码',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            McButton.primary(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  McFeedback.showSuccess(context, message: '表单验证通过！');
                }
              },
              child: const Text('提交表单'),
            ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return '此字段不能为空';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return '邮箱不能为空';
    if (!value.contains('@')) return '请输入有效的邮箱地址';
    return null;
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
