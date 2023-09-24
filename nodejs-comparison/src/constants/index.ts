import { ColumnOptions } from "typeorm";

export const timestamptzColumnOptions: ColumnOptions = {
  type: "timestamptz",
  // need this to match postgres precision with JS precision, when comparing dates in SQL
  precision: 3,
};
