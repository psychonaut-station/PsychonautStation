import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const SpaceNinja: Antagonist = {
  key: 'spaceninja',
  name: 'Space Ninja',
  description: [
    multiline`
     Örümcek Klanı, daha mükemmel bir varlık durumuna ulaşmak ve
	 Postmodern bir Uzay Bushidosu'nu takip etmek için insan
	 bedeninin bir tür büyütülmesini uygular.
    `,

    multiline`
      Bir katana, airlock ve APC'leri hacklemek için eldivenler,
	  nerdeyse görünmez olmanızı sağlayan bir kıyafet ve kitinizdeki
	  çeşitli yeteneklerle donatılmış, işbirlikçi uzay ninjası olun.
	  Herkesi tutuklu olarak göstermek için tutuklama konsollarını hackleyin
	  ve hatta istasyonda kaosa neden olmak için ve daha fazla tehdite yol açmak için
	  iletişim konsollarını hackleyin!
    `,
  ],
  category: Category.Midround,
};

export default SpaceNinja;
