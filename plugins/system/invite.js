import cfg from '../../lib/config/config.js'

export class invite extends plugin {
  constructor () {
    super({
      name: 'invite',
      dsc: '主人邀请自动进群',
      event: 'request.group.invite'
    })
  }

  async accept () {
    if (!this.e.isMaster) {
      logger.mark(`[邀请加群]：${this.e.group_name}：${this.e.group_id}`)
      return
    }
    logger.mark(`[主人邀请加群]：${this.e.group_name}：${this.e.group_id}`)
    this.e.approve(true)
    this.e.bot.pickFriend(this.e.user_id).sendMsg(`已同意加群：${this.e.group_name}`)
  }
}
