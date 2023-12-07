import { mapSeries, observeSeries as observeSeriesImpl } from "@node-frp/core";

export { mapSeries };

export const observeSeries = (ser) => (hdl) => () =>
  observeSeriesImpl(ser)((val) => hdl(val)());
