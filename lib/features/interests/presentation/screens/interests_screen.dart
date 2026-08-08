import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/features/auth/data/models/Category_Model.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_bloc.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_event.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_state.dart';
import 'package:library_app1/features/interests/domain/entities/interest_entity.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final selectedIds = authState is AuthSuccess
        ? (authState.user.interests ?? const <dynamic>[])
            .whereType<CategoryModel>()
            .map((c) => c.id)
            .toList()
        : <int>[];
    context.read<InterestsBloc>().add(
          LoadInterestsEvent(selectedInterestIds: selectedIds),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InterestsBloc, InterestsState>(
      listenWhen: (previous, current) =>
          current is InterestsSaveSuccess || current is InterestsError,
      listener: (context, state) {
        if (state is InterestsSaveSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Interests updated successfully!')),
          );
        } else if (state is InterestsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
              backgroundColor: const Color(0xfffcfbfa),
              appBar: AppBar(
                backgroundColor: const Color(0xfffcfbfa),
                elevation: 0,
                title: const Text(
                  'My Interests',
                  style: TextStyle(
                    color: Color(0xff2d2d2d),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, InterestsState state) {
    if (state is InterestsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is InterestsError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Color(0xff2d2d2d)),
        ),
      );
    }
    if (state is InterestsLoaded ||
        state is InterestsSaving ||
        state is InterestsSaveSuccess) {
      final interests = state is InterestsLoaded
          ? state.interests
          : state is InterestsSaving
              ? state.interests
              : (state as InterestsSaveSuccess).interests;
      final isSaving = state is InterestsSaving;

      return Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select your favourite genres',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2d2d2d),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildChipsGrid(interests, context),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              final selectedIds = interests
                                  .where((i) => i.isSelected)
                                  .map((i) => i.id)
                                  .toList();
                              context.read<InterestsBloc>().add(
                                    SaveInterestsEvent(
                                        selectedInterestIds: selectedIds),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffe61b72),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildChipsGrid(List<InterestEntity> interests, BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: interests.map((interest) {
        final isSelected = interest.isSelected;
        return GestureDetector(
          onTap: () {
            context
                .read<InterestsBloc>()
                .add(ToggleInterestEvent(interestId: interest.id));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xffd4c5f9).withValues(alpha: 0.25)
                  : const Color(0xff2d2d2d).withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xff7c5cbf).withValues(alpha: 0.5)
                    : const Color(0xff2d2d2d).withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: const Color(0xff7c5cbf).withValues(alpha: 0.8),
                    ),
                  ),
                Text(
                  interest.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xff7c5cbf)
                        : const Color(0xff2d2d2d).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}