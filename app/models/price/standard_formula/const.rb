module Price::StandardFormula::Const
  
  PriceByMonth = 0
  PriceByDay = 1
  PriceByItem = 2

  PriceBySumDurationSecond = 13

  PriceBySomeVolumeConst = [14, 15, 16, 17]
  PriceByCountVolumeItem = 14
  PriceBySumVolumeMByte = 15
  PriceBySumVolumeKByte = 16
  PriceBySumDuration = 17

  FixedPriceIfUsedInOneDayDuration = 18
  FixedPriceIfUsedInOneDayVolume = 19
  FixedPriceIfUsedInOneDayAny = 20
  PriceByMonthIfUsed = 21
  PriceByItemIfUsed = 22

  MaxVolumesForFixedPriceConst = [30, 31, 32]
  MaxDurationMinuteForFixedPrice = 30
  MaxCountVolumeForFixedPrice = 31
  MaxSumVolumeMByteForFixedPrice = 32
  
  MaxVolumesForFixedPriceIfUsedConst = [33, 34, 35]
  MaxDurationMinuteForFixedPriceIfUsed = 33
  MaxCountVolumeForFixedPriceIfUsed = 34
  MaxSumVolumeMByteForFixedPriceIfUsed = 35

  MaxForSpecialPrice = [36, 37, 38]
  MaxDurationMinuteForSpecialPrice = 36
  MaxCountVolumeForSpecialPrice = 37
  MaxSumVolumeMByteForSpecialPrice = 38

  TurbobuttonsConst = [40, 41]
  TurbobuttonMByteForFixedPrice = 40
  TurbobuttonMByteForFixedPriceDay = 41

#  MaxDurationMinuteWithMultipleUseMonth = 50
#  MaxDurationMinuteWithMultipleUseDay = 51

  MaxCountVolumeWithMultipleUseMonth = 52
  MaxCountVolumeWithMultipleUseDay = 53

  MaxSumVolumeMByteWithMultipleUseMonth = 54
  MaxSumVolumeMByteWithMultipleUseDay = 55
  
  TwoStepPriceMaxDurationMinute = 61

  TwoStepPriceDurationMinute = 70
  ThreeStepPriceDurationMinute = 71
  
  UnlimitedFormulaConsts = MaxVolumesForFixedPriceConst + MaxVolumesForFixedPriceIfUsedConst + MaxForSpecialPrice + TurbobuttonsConst
  
  ParamsByFormula = {
    PriceByMonth => {'window_over' => false, 'params' => ['price']},
    PriceByDay => {'window_over' => false, 'params' => ['price']},
    PriceByItem => {'window_over' => false, 'params' => ['price']},
    PriceBySumDurationSecond => {'window_over' => true, 'params' => ['price']},
    PriceByCountVolumeItem => {'window_over' => false, 'params' => ['price']},
    PriceBySumVolumeMByte => {'window_over' => false, 'params' => ['price']},
    PriceBySumVolumeKByte => {'window_over' => false, 'params' => ['price']},
    PriceBySumDuration => {'window_over' => false, 'params' => ['price']},
    FixedPriceIfUsedInOneDayDuration => {'window_over' => false, 'params' => ['price']},
    FixedPriceIfUsedInOneDayVolume => {'window_over' => false, 'params' => ['price']},
    FixedPriceIfUsedInOneDayAny => {'window_over' => false, 'params' => ['price']},
    PriceByMonthIfUsed => {'window_over' => false, 'params' => ['price']},
    PriceByItemIfUsed => {'window_over' => false, 'params' => ['price']},

    MaxDurationMinuteForFixedPrice => {'window_over' => true, 'params' => ['price', 'max_duration_minute']},
    MaxCountVolumeForFixedPrice => {'window_over' => true, 'params' => ['price', 'max_count_volume']},
    MaxSumVolumeMByteForFixedPrice => {'window_over' => true, 'params' => ['price', 'max_sum_volume']},
    MaxDurationMinuteForFixedPriceIfUsed => {'window_over' => true, 'params' => ['price', 'max_duration_minute']},
    MaxCountVolumeForFixedPriceIfUsed => {'window_over' => true, 'params' => ['price', 'max_count_volume']},
    MaxSumVolumeMByteForFixedPriceIfUsed => {'window_over' => true, 'params' => ['price', 'max_sum_volume']},

    MaxDurationMinuteForSpecialPrice => {'window_over' => true, 'params' => ['price', 'max_duration_minute']},
    MaxCountVolumeForSpecialPrice => {'window_over' => true, 'params' => ['price', 'max_count_volume']},
    MaxSumVolumeMByteForSpecialPrice => {'window_over' => true, 'params' => ['price', 'max_sum_volume']},
    TurbobuttonMByteForFixedPrice => {'window_over' => false, 'params' => ['price', 'max_sum_volume']},
    TurbobuttonMByteForFixedPriceDay => {'window_over' => false, 'params' => ['price', 'max_sum_volume']},

    MaxCountVolumeWithMultipleUseMonth => {'window_over' => true, 'params' => ['price', 'max_count_volume']},
    MaxCountVolumeWithMultipleUseDay => {'window_over' => false, 'params' => ['price', 'max_count_volume']},
    MaxSumVolumeMByteWithMultipleUseMonth => {'window_over' => false, 'params' => ['price', 'max_sum_volume']},
    MaxSumVolumeMByteWithMultipleUseDay => {'window_over' => false, 'params' => ['price', 'max_sum_volume']},

    TwoStepPriceMaxDurationMinute => {'window_over' => true, 'params' => ['price_0', 'price_1', 'max_duration_minute', 'duration_minute_1']},
    TwoStepPriceDurationMinute => {'window_over' => false, 'params' => ['price_0', 'price_1', 'duration_minute_1']},
    ThreeStepPriceDurationMinute => {'window_over' => false, 'params' => ['price_0', 'price_1', 'price_2', 'duration_minute_2', 'duration_minute_1']},
  }
  
end

  
#  _stf_zero_count_volume_item = 11;  _stf_zero_sum_volume_m_byte = 12;
#  _stf_price_by_sum_duration_second = 13; _stf_price_by_count_volume_item = 14; _stf_price_by_sum_volume_m_byte = 15; _stf_price_by_sum_volume_k_byte = 16 
#  _stf_price_by_sum_duration_minute = 17; _stf_fixed_price_if_used_in_1_day_duration = 18; _stf_fixed_price_if_used_in_1_day_volume = 19;
#  _stf_price_by_1_month_if_used = 20; _stf_price_by_1_item_if_used = 21; _stf_fixed_price_if_used_in_1_day_any = 22;
  
