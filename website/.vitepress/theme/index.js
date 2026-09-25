import { h } from 'vue';
import DefaultTheme from 'vitepress/theme';
import BTCFooter from './components/BTCFooter.vue';
import DmlGraph from './components/DmlGraph.vue';
import VersionBanner from './components/VersionBanner.vue';
import VersionSwitcher from './components/VersionSwitcher.vue';
import VersionedNavLink from './components/VersionedNavLink.vue';
import './custom.css';

export default {
    extends: DefaultTheme,
    Layout() {
        return h(DefaultTheme.Layout, null, {
            'layout-top': () => h(VersionBanner),
            'layout-bottom': () => h(BTCFooter, { context: 'dml-lib' })
        });
    },
    enhanceApp({ app }) {
        app.component('BTCFooter', BTCFooter);
        app.component('DmlGraph', DmlGraph);
        app.component('VersionSwitcher', VersionSwitcher);
        app.component('VersionedNavLink', VersionedNavLink);
    }
};
