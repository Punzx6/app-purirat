import 'package:flutter/material.dart';
import 'package:myproject/ui/login_page.dart';
import 'package:myproject/ui/user_store.dart';
import '../services/user_store.dart';
import '../login_page.dart';

class ForgotPage extends StatefulWidget { const ForgotPage({super.key}); @override State<ForgotPage> createState()=>_ForgotPageState(); }

class _ForgotPageState extends State<ForgotPage>{
  final userCtrl=TextEditingController(), phoneCtrl=TextEditingController(),
        newPassCtrl=TextEditingController(); bool obscure=true;

  Future<void> _reset() async {
    final u = await UserStore.find(userCtrl.text.trim());
    if(u!=null && u.isNotEmpty && u['phone']==phoneCtrl.text.trim()){
      await UserStore.updatePassword(u['username'], newPassCtrl.text);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('เปลี่ยนรหัสผ่านแล้ว')));
      Navigator.pushReplacement(
        context,MaterialPageRoute(builder:(_)=>const LoginPage()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('ข้อมูลยืนยันไม่ถูกต้อง')));
    }
  }

  @override
  Widget build(c)=>Scaffold(
    appBar:AppBar(title:const Text('Reset Password')),
    body:Padding(
      padding:const EdgeInsets.all(24),
      child:Column(children:[
        _field(userCtrl ,'Username'),
        _field(phoneCtrl,'Phone (verify)',keyType:TextInputType.phone),
        TextField(
          controller:newPassCtrl,obscureText:obscure,
          decoration:InputDecoration(labelText:'New Password',
            border:const OutlineInputBorder(),
            suffixIcon:IconButton(
              icon:Icon(obscure?Icons.visibility:Icons.visibility_off),
              onPressed:()=>setState(()=>obscure=!obscure))),
        ),
        const SizedBox(height:20),
        ElevatedButton(onPressed:_reset,child:const Text('Confirm')),
      ])));
  Widget _field(TextEditingController c,String l,{TextInputType keyType=TextInputType.text})=>
    Padding(padding:const EdgeInsets.only(bottom:12),
      child:TextField(controller:c,keyboardType:keyType,
        decoration:InputDecoration(labelText:l,border:const OutlineInputBorder())));
}
