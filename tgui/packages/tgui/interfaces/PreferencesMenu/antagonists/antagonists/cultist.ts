import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Cultist: Antagonist = {
  key: 'cultist',
  name: 'Cultist',
  description: [
    multiline`
      Kan Geometresi, Nar-Sie, müritlerinin bir kısmını Space Station 13'e gönderdi.
	  Bir kültist olaraki emrinizde her duruma uygun bol miktarda kült büyüsü var.
	  Kardeşlerinle birlikte cehennem cehennem tanrıçanın bir avatarını çağırmalısın.
    `,

    multiline`
      Kan büyüsüyle donanarak mürettebat üyelerini Kan Tarikatı'na
     mensup üye yap, yoluna çıkanları kurban et ve Nar-Sie'yi çağır.
	  
    `,
  ],
  category: Category.Roundstart,
};

export default Cultist;
