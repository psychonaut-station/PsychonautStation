import { ChannelIterator } from './ChannelIterator';

describe('ChannelIterator', () => {
  let channelIterator: ChannelIterator;

  beforeEach(() => {
    channelIterator = new ChannelIterator();
  });

  it('should cycle through channels properly', () => {
    expect(channelIterator.current()).toBe('Say');
    expect(channelIterator.next()).toBe('Radio');
    expect(channelIterator.next()).toBe('Me');
    expect(channelIterator.next()).toBe('OOC');
    expect(channelIterator.next()).toBe('LOOC'); // PSYCHONAUT EDIT ADDITION - LOOC
    expect(channelIterator.next()).toBe('Say'); // Admin is blacklisted so it should be skipped
  });

  it('should set a channel properly', () => {
    channelIterator.set('OOC');
    expect(channelIterator.current()).toBe('OOC');
  });

  // PSYCHONAUT EDIT ADDITION START - LOOC
  it('should set a channel properly', () => {
    channelIterator.set('LOOC');
    expect(channelIterator.current()).toBe('LOOC');
  });
  // PSYCHONAUT EDIT ADDITION END

  it('should return true when current channel is "Say"', () => {
    channelIterator.set('Say');
    expect(channelIterator.isSay()).toBe(true);
  });

  it('should return false when current channel is not "Say"', () => {
    channelIterator.set('Radio');
    expect(channelIterator.isSay()).toBe(false);
  });

  it('should return true when current channel is visible', () => {
    channelIterator.set('Say');
    expect(channelIterator.isVisible()).toBe(true);
  });

  it('should return false when current channel is not visible', () => {
    channelIterator.set('OOC');
    expect(channelIterator.isVisible()).toBe(false);
  });

  // PSYCHONAUT EDIT ADDITION START - LOOC
  it('should return false when current channel is not visible', () => {
    channelIterator.set('LOOC');
    expect(channelIterator.isVisible()).toBe(false);
  });
  // PSYCHONAUT EDIT ADDITION END

  it('should not leak a message from a blacklisted channel', () => {
    channelIterator.set('Admin');
    expect(channelIterator.next()).toBe('Admin');
  });
});
