import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/common/constants/assets.dart';
import '../../../data/common/constants/routes.dart';
import '../../../data/services/navigation/navigation.dart';
import '../../../di/get_it.dart';
import '../../bloc/input_bloc.dart';
import '../../components/custom_text_field.dart';
import '../../themes/colors.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late TextEditingController startDateController;
  late TextEditingController averagePeriodController;
  late TextEditingController lengthOfCycleController;
  late FocusNode startDateFocusNode;
  late FocusNode lengthOfCycleFocusNode;
  late FocusNode averagePeriodFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    startDateFocusNode = FocusNode();
    startDateController = TextEditingController();
    averagePeriodFocusNode = FocusNode();
    averagePeriodController = TextEditingController();
    lengthOfCycleController = TextEditingController();
    lengthOfCycleFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    startDateController.dispose();
    startDateFocusNode.dispose();
    averagePeriodController.dispose();
    averagePeriodFocusNode.dispose();
    lengthOfCycleFocusNode.dispose();
    lengthOfCycleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
          ),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
            pinned: true,
            expandedHeight: size.height / 2.3,
            stretch: true,
            elevation: 0,
            toolbarHeight: 0.0,
            collapsedHeight: 0.0,
            backgroundColor: AppColors.white,
            foregroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                Assets.inputImage,
                fit: BoxFit.fill,
              ),
            )),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<InputCubit>().setLastPeriod(context: context, controller: startDateController);
                  },
                  child: CustomTextFormField(
                    labelText: 'What\'s the start date of your last period?',
                    controller: startDateController,
                    focusNode: startDateFocusNode,
                    nextNode: averagePeriodFocusNode,
                    hintText: 'Last Period',
                    autovalidateMode: AutovalidateMode.disabled,
                    enabled: false,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      }
                      return null;
                    },
                  ),
                ),
                CustomTextFormField(
                  labelText: 'On average, how many days does your period last?',
                  controller: averagePeriodController,
                  focusNode: averagePeriodFocusNode,
                  nextNode: lengthOfCycleFocusNode,
                  autovalidateMode: AutovalidateMode.disabled,
                  textInputType: TextInputType.number,
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      context.read<InputCubit>().setAverageLengthOfPeriod(value: value);
                    }
                  },
                  hintText: 'Length of Period',
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    if(int.parse(value) > 7 || int.parse(value) < 4){
                      return 'Invalid input';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  labelText: 'what\'s the average time between the first days of your period?',
                  controller: lengthOfCycleController,
                  focusNode: lengthOfCycleFocusNode,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.disabled,
                  textInputType: TextInputType.number,
                  hintText: 'Length of Cycle',
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      context.read<InputCubit>().setAverageLengthOfCycle(value: value);
                    }
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    if(int.parse(value) > 34 || int.parse(value) < 28){
                      return 'Invalid input';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<InputCubit>().getCycleInfo();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Center(
            child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        )),
      ),
    );
  }
}
