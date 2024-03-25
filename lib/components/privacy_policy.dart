import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {


  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0XFFF1F1F6),
        appBar: AppBar(
          title: Text(
            "سياسة الخصوصية",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text
                        ("....فريق يؤكد على انه",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "تنطبق هذه السياسة على جميع المعلومات التي يتم جمعها أو المقدمة على موقعنا الإلكتروني. يمكن لزوار الموقع تصفحه والحصول على المعلومات التي يبحثون عنها والاشتراك في مختلف الأدوات والبرامج التي يقدمها الموقع وتلقي الرسائل الإلكترونية وتحميل المواد بشكل مجاني. خلال هذه العمليات، لا نقوم بجمع سوى المعلومات الشخصية المقدمة طوعاً من قبل المتصفح لهذا الموقع، وقد يشمل ذلك، ولكن ليس على سبيل الحصر، الاسم وعنوان البريد الإلكتروني، ومعلومات الاتصال، وأية بيانات أو تفاصيل ديموغرافية أخرى. نحن لا نشارك المعلومات الشخصية التي تقدمها من خلال موقعنا على شبكة الإنترنت مع أية مؤسسة أو شركة أو حكومة أو وكالة حكومية أو أي نوع من المنظمات الأخرى. ونلتزم في الكشف عن المعلومات الشخصية في حالات استثنائية حسب قانون البلد الذي نعمل فيه. نستخدم المعلومات التي يقدمها متصفح الموقع طوعاً لتقديم عدة خدمات مثل النشرات الإخبارية عن طريق البريد الإلكتروني، ودعوات للندوات والمؤتمرات، أو تنبيهات حول برامج أو أنشطة أو مواد ننشرها على موقعنا.",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 50,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text
                        ("....فريق يؤكد على انه",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "تنطبق هذه السياسة على جميع المعلومات التي يتم جمعها أو المقدمة على موقعنا الإلكتروني. يمكن لزوار الموقع تصفحه والحصول على المعلومات التي يبحثون عنها والاشتراك في مختلف الأدوات والبرامج التي يقدمها الموقع وتلقي الرسائل الإلكترونية وتحميل المواد بشكل مجاني. خلال هذه العمليات، لا نقوم بجمع سوى المعلومات الشخصية المقدمة طوعاً من قبل المتصفح لهذا الموقع، وقد يشمل ذلك، ولكن ليس على سبيل الحصر، الاسم وعنوان البريد الإلكتروني، ومعلومات الاتصال، وأية بيانات أو تفاصيل ديموغرافية أخرى. نحن لا نشارك المعلومات الشخصية التي تقدمها من خلال موقعنا على شبكة الإنترنت مع أية مؤسسة أو شركة أو حكومة أو وكالة حكومية أو أي نوع من المنظمات الأخرى. ونلتزم في الكشف عن المعلومات الشخصية في حالات استثنائية حسب قانون البلد الذي نعمل فيه. نستخدم المعلومات التي يقدمها متصفح الموقع طوعاً لتقديم عدة خدمات مثل النشرات الإخبارية عن طريق البريد الإلكتروني، ودعوات للندوات والمؤتمرات، أو تنبيهات حول برامج أو أنشطة أو مواد ننشرها على موقعنا.",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

}
