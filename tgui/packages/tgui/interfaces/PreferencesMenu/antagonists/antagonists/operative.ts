import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const OPERATIVE_MECHANICAL_DESCRIPTION = multiline`
  Nükleer diski alın ve nükleer füzyon patlayıcısını kullanmak için
  etkinleştirmek için kullanın ve istasyonu yok edin.
`;

const Operative: Antagonist = {
  key: 'operative',
  name: 'Nuclear Operative',
  description: [
    multiline`
      Tebrikler, ajan. Sendika Nükleer Operatif saldırı ekibine katılmak
	  üzere seçildiniz. Görevinizi kabul etseniz de etmeseniz de, Nanotrasen'in
	  gelişmiş araştırma tesisini yok etmeniz. Bu doğru,
      Space Station 13'e gidiyorsun.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Operative;
