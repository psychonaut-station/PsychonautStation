import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const CyberPolice: Antagonist = {
  key: 'cyberpolice',
  name: 'Cyber Police',
  description: [
    multiline`
    Siber Otorite, dijital alemin bıçak sırtında, icra memurlarını sistem
	uyumunu korumakla görevlendirdi.
    `,

    multiline`
    Rafine dövüş sanat becerilerini kullanarak, sanal alanda bitrunnerları
	yok edin. Bunu yaparken şık görünün. Cyber Police, sanal alandaki
	çetelerden (elitler ve oyuncular dışı) ortaya çıkan kısa ömürlü savaş rolleridir.
    `,
  ],
  category: Category.Midround,
};

export default CyberPolice;
