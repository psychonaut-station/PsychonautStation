import { BooleanLike } from 'tgui-core/react';

export type CrewRecordData = {
  assigned_view: string;
  authenticated: BooleanLike;
  station_z: BooleanLike;
  records: CrewRecord[];
  min_age: number;
  max_age: number;
};

export type CrewRecord = {
  age: number;
  blood_type: string;
  crew_ref: string;
  gender: string;
  major_disabilities: string;
  minor_disabilities: string;
  name: string;
  quirk_notes: string;
  rank: string;
  species: string;
  trim: string;
  employment_records: string;
  exploit_records: string;
};
