import { Antagonist, Category } from '../base';
import { BLOB_MECHANICAL_DESCRIPTION } from './blob';
import { multiline } from 'common/string';

const BlobInfection: Antagonist = {
  key: 'blobinfection',
  name: 'Blob Infection',
  description: [
    multiline`
      Vardiyanın ortasında herhangi bir noktada, enfeksiyona yakalanmak
      sizi korkunç bir blob'a dönüştürecektir.
    `,
    BLOB_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default BlobInfection;
