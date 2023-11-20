import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const BLOB_MECHANICAL_DESCRIPTION = multiline`
  Blob istasyonu istila eder, uzay gemisinin gövdesi, sabitlenen eşyalar ve
  yaratıklar dahil önüne çıkan her şeyi yok eder. Kitlenizi yayın, kaynakları toplayın ve
  tüm istasyonu sindirin. Savunmanızı hazırladığınıza emin olun, çünkü
  mürettebat varlığınız konusunda uyarılacak!
`;

const Blob: Antagonist = {
  key: 'blob',
  name: 'Blob',
  description: [BLOB_MECHANICAL_DESCRIPTION],
  category: Category.Midround,
};

export default Blob;
