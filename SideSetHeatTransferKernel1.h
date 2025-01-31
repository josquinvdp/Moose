//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "InterfaceKernel.h"

// Forward Declarations

/**
 * DG kernel for interfacing diffusion between two variables on adjacent blocks
 */
class SideSetHeatTransferKernel1 : public InterfaceKernel
{
public:
  SideSetHeatTransferKernel1(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual(Moose::DGResidualType type) override;
  virtual Real computeQpJacobian(Moose::DGJacobianType type) override;

  const int &_IsDebug;

  /// Conductivity of gap divided by effective gap width
  const MaterialProperty<Real> & _cond;
  /// Bulk temperature of gap
  const VariableValue * _Tbulk_var;
  const MaterialProperty<Real> * _Tbulk_mat;
  /// Convective heat transfer coefficient (master face)
  const MaterialProperty<Real> & _hp;
  /// Convective heat transfer coefficient (neighbor face)
  const MaterialProperty<Real> & _hm;
  /// Master face effective emissivity \epsilon^+\sigma(1-\rho^-)/(1-\rho^+\rho^-)
  const MaterialProperty<Real> & _eps_p;
  /// Neighbor face effective emissivity \epsilon^-\sigma(1-\rho^+)/(1-\rho^+\rho^-)
  const MaterialProperty<Real> & _eps_m;
};
