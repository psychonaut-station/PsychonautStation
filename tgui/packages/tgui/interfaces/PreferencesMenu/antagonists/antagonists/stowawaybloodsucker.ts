import { type Antagonist, Category } from '../base';

const StowawayBloodsucker: Antagonist = {
  key: 'stowawaybloodsucker',
  name: 'Stowaway Bloodsucker',
  description: [
    `
      A Bloodsucker that found its way onto the station or arrival shuttle
      unbeknownst to the crewmembers on board.
      Use your Vampiric abilities as best you can.
      Scrape by Space Station 13, or take over it, vassalizing your way.
    `,
  ],
  category: Category.Latejoin,
};

export default StowawayBloodsucker;
