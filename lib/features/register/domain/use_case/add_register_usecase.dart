

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:bloodbank/core/error/failure.dart';
import 'package:bloodbank/features/register/domain/entity/register_entity.dart';
import 'package:bloodbank/features/register/domain/repository/register_repository.dart';

import '../../../../app/use_case/usecase.dart';

class AddRegisterParams {
    final String name;
    final String email;
    final String password;
    final String phone;
  

    AddRegisterParams({
        required this.name,
        required this.email,
        required this.password,
        required this.phone,
      
    });

}

  class AddRegisterUsecase implements UsecaseWithParams<void, AddRegisterParams> {

    final IRegisterRepository iregisterRepository;

    AddRegisterUsecase({required IRegisterRepository registerRepository}) : iregisterRepository = registerRepository;

    @override
    Future<Either<Failure, void>> call(AddRegisterParams params) async {
        //to entity conversion here
        final register = RegisterEntity(
            name: params.name,
            email: params.email,
            password: params.password,
            phone: params.phone,
                      id: '',
        );
        return await iregisterRepository.addRegister(register);
    }



}

