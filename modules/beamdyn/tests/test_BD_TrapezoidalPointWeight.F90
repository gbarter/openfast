module test_BD_TrapezoidalPointWeight

use test_tools
use BeamDyn

implicit none

private
public :: test_BD_TrapezoidalPointWeight_suite

contains

!> Collect all exported unit tests
subroutine test_BD_TrapezoidalPointWeight_suite(testsuite)
   type(unittest_type), allocatable, intent(out) :: testsuite(:)
   testsuite = [ &
               new_unittest("test_BD_TrapezoidalPointWeight_2station", test_BD_TrapezoidalPointWeight_2station), &
               new_unittest("test_BD_TrapezoidalPointWeight_3station", test_BD_TrapezoidalPointWeight_3station) &
               ]
end subroutine

subroutine test_BD_TrapezoidalPointWeight_2station(error)
   type(error_type), allocatable, intent(out) :: error

   type(BD_ParameterType)     :: p

   integer(IntKi)             :: nqp
   integer(IntKi)             :: refine
   integer(IntKi)             :: station_total
   real(BDKi), allocatable    :: station_eta(:)
   real(BDKi), allocatable    :: baseline_QPtN(:)
   real(BDKi), allocatable    :: baseline_QPtW(:)

   integer(IntKi)             :: ErrStat
   character                  :: ErrMsg
   character(1024)            :: testname

   ! --------------------------------------------------------------------------
   testname = "test_BD_TrapezoidalPointWeight_2station_8refine"

   station_total = 2

   call AllocAry(station_eta, station_total, "station_eta", ErrStat, ErrMsg)

   ! simple case where we have enpoints only; typical with constant cross sections
   station_eta(1:station_total) = (/0., 1./)

   refine = 8

   nqp = (station_total - 1) * refine + 1

   p = simpleParameterType(1, 1, nqp, 0, refine)

   call AllocAry(baseline_QPtN, nqp, "baseline_QPtN", ErrStat, ErrMsg)
   call AllocAry(baseline_QPtW, nqp, "baseline_QPtW", ErrStat, ErrMsg)

   baseline_QPtN(1:nqp) = (/-1., -0.75, -0.5, -0.25, 0., 0.25, 0.5, 0.75, 1./)
   baseline_QPtW(1:nqp) = (/0.125, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.125/)

   call BD_TrapezoidalPointWeight(p, station_eta, station_total)

   call check_array(error, baseline_QPtN, p%QPtN, testname, thr=tolerance); if (allocated(error)) return
   call check_array(error, baseline_QPtW, p%QPtWeight, testname, thr=tolerance); if (allocated(error)) return

   deallocate (station_eta)
   deallocate (baseline_QPtN)
   deallocate (baseline_QPtW)

   call BD_DestroyParam(p, ErrStat, ErrMsg)

end subroutine

subroutine test_BD_TrapezoidalPointWeight_3station(error)
   type(error_type), allocatable, intent(out) :: error

   type(BD_ParameterType)     :: p

   integer(IntKi)             :: nqp
   integer(IntKi)             :: refine
   integer(IntKi)             :: station_total
   real(BDKi), allocatable    :: station_eta(:)
   real(BDKi), allocatable    :: baseline_QPtN(:)
   real(BDKi), allocatable    :: baseline_QPtW(:)

   integer(IntKi)             :: ErrStat
   character                  :: ErrMsg
   character(1024)            :: testname

   ! --------------------------------------------------------------------------
   testname = "test_BD_TrapezoidalPointWeight_3station_2refine"

   ! provide three stations, unequally distributed
   ! refine by factor of two

   station_total = 3

   call AllocAry(station_eta, station_total, "station_eta", ErrStat, ErrMsg)

   station_eta(1:station_total) = (/0., 0.25, 1./)

   refine = 2

   nqp = (station_total - 1) * refine + 1

   p = simpleParameterType(1, 1, nqp, 0, refine)

   call AllocAry(baseline_QPtN, nqp, "baseline_QPtN", ErrStat, ErrMsg)
   call AllocAry(baseline_QPtW, nqp, "baseline_QPtW", ErrStat, ErrMsg)

   baseline_QPtN(1:nqp) = (/-1., -0.75, -0.5, 0.25, 1./)
   baseline_QPtW(1:nqp) = (/0.125, 0.25, 0.125 + 0.5 * 0.75, 0.75, 0.5 * 0.75/)

   call BD_TrapezoidalPointWeight(p, station_eta, station_total)

   call check_array(error, baseline_QPtN, p%QPtN, testname, thr=tolerance); if (allocated(error)) return
   call check_array(error, baseline_QPtW, p%QPtWeight, testname, thr=tolerance); if (allocated(error)) return

   deallocate (station_eta)
   deallocate (baseline_QPtN)
   deallocate (baseline_QPtW)

   call BD_DestroyParam(p, ErrStat, ErrMsg)

end subroutine
end module
