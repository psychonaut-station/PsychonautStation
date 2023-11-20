import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Abductor: Antagonist = {
  key: 'abductor',
  name: 'Abductor',
  description: [
    multiline`
      Abductor'ler tüm türleri katologlamaya kararlı,
      teknolojik olarak gelişmiş bir uzay topluluğudur. Ancak ne yazık ki denekleri için kullandıkları yöntemler
      oldukça istilacıdır.
    `,

    multiline`
      Siz ve partneriniz abducator bilim insanı ve ajanı olacaksınız.
      Bir ajan olarak, mütevazi kurbanlarınızı kaçırın ve onları kendi UFO'nuza geri getirin.
      Bir bilim insanı olarak ajanınız için kurbanları bulun, güvende tutun, ve
      kimi getirirlerse getirsinler ameliyat edin.
    `,
  ],
  category: Category.Midround,
};

export default Abductor;
