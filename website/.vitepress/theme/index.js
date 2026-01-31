import DefaultTheme from 'vitepress/theme'
import BTCFooter from './components/BTCFooter.vue'
import UnitOfWorkAnimation from './components/UnitOfWorkAnimation.vue'
import './custom.css'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('BTCFooter', BTCFooter)
    app.component('UnitOfWorkAnimation', UnitOfWorkAnimation)
  }
}
