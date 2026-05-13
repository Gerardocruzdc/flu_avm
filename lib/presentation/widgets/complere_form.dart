import 'package:flutter/material.dart';

class ComplereForm extends StatelessWidget {
  const ComplereForm({super.key});

    @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color.fromRGBO(64, 64, 64, 0.86),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 14),
              blurRadius: 36,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                onChanged: (value) => { },
                style:TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Pon tu nombre',
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.black45,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => { },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.black45,
                        foregroundColor:Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border: Border.all(color: Colors.white70, width: 2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('#F44336', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () => { },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black45,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Conectar', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

}