import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'
import llmstxt from 'vitepress-plugin-llms'
// https://vitepress.dev/reference/site-config

const siteUrl = 'https://dml.beyondthecloud.dev'
const siteTitle = 'DML Lib'
const siteDescription = 'Open-source Apex library for Salesforce DML operations. Fluent API for insert, update, upsert, delete, undelete and publish, with relationship handling, FLS and sharing control, and DML mocking in unit tests. Free, MIT licensed, part of Apex Fluently by Beyond The Cloud.'

const latest = '3.2.0'

// Frozen: an old version's pages never change again.
const v310 = [
  {
    text: 'Docs',
    items: [
      { text: 'Introduction', link: '/3.1.0/introduction' },
      { text: 'Installation', link: '/3.1.0/installation' }
    ]
  },
  {
    text: 'DMLs',
    collapsed: false,
    items: [
      { text: 'Insert', link: '/3.1.0/dml/insert' },
      { text: 'Update', link: '/3.1.0/dml/update' },
      { text: 'Upsert', link: '/3.1.0/dml/upsert' },
      { text: 'Delete', link: '/3.1.0/dml/delete' },
      { text: 'Undelete', link: '/3.1.0/dml/undelete' },
      { text: 'Merge', link: '/3.1.0/dml/merge' },
      { text: 'Publish', link: '/3.1.0/dml/publish' },
      { text: 'Result', link: '/3.1.0/result' }
    ]
  },
  {
    text: 'Mocking',
    collapsed: true,
    items: [
      { text: 'Introduction', link: '/3.1.0/mocking/mocking' },
      { text: 'Insert', link: '/3.1.0/mocking/insert' },
      { text: 'Update', link: '/3.1.0/mocking/update' },
      { text: 'Upsert', link: '/3.1.0/mocking/upsert' },
      { text: 'Delete', link: '/3.1.0/mocking/delete' },
      { text: 'Undelete', link: '/3.1.0/mocking/undelete' },
      { text: 'Merge', link: '/3.1.0/mocking/merge' },
      { text: 'Publish', link: '/3.1.0/mocking/publish' }
    ]
  },
  {
    text: 'Configuration',
    collapsed: true,
    items: [
      { text: 'Field-Level Security', link: '/3.1.0/configuration/field-level-security' },
      { text: 'Sharing Mode', link: '/3.1.0/configuration/sharing-mode' },
      { text: 'DmlOptions', link: '/3.1.0/configuration/dml-options' }
    ]
  },
  {
    text: 'Architecture',
    collapsed: true,
    items: [
      { text: 'Rollback', link: '/3.1.0/architecture/rollback' },
      { text: 'Registration', link: '/3.1.0/architecture/registration' }
    ]
  }
]

const current = [
  {
    text: 'Docs',
    items: [
      { text: 'Introduction', link: '/introduction' },
      { text: 'Installation', link: '/installation' },
      { text: 'Changelog', link: '/release' }
    ]
  },
  {
    text: 'DMLs',
    collapsed: false,
    items: [
      { text: 'Insert', link: '/dml/insert' },
      { text: 'Update', link: '/dml/update' },
      { text: 'Upsert', link: '/dml/upsert' },
      { text: 'Delete', link: '/dml/delete' },
      { text: 'Hard Delete', link: '/dml/hard-delete' },
      { text: 'Undelete', link: '/dml/undelete' },
      { text: 'Merge', link: '/dml/merge' },
      { text: 'Publish', link: '/dml/publish' },
      { text: 'Record & Records', link: '/dml/record-builders' },
      { text: 'Result', link: '/result' }
    ]
  },
  {
    text: 'Mocking',
    collapsed: true,
    items: [
      { text: 'Introduction', link: '/mocking/mocking' },
      { text: 'Insert', link: '/mocking/insert' },
      { text: 'Update', link: '/mocking/update' },
      { text: 'Upsert', link: '/mocking/upsert' },
      { text: 'Delete', link: '/mocking/delete' },
      { text: 'Undelete', link: '/mocking/undelete' },
      { text: 'Merge', link: '/mocking/merge' },
      { text: 'Publish', link: '/mocking/publish' }
    ]
  },
  {
    text: 'Configuration',
    collapsed: true,
    items: [
      { text: 'Field-Level Security', link: '/configuration/field-level-security' },
      { text: 'Sharing Mode', link: '/configuration/sharing-mode' },
      { text: 'DmlOptions', link: '/configuration/dml-options' },
      { text: 'Operation Order', link: '/configuration/operation-order' }
    ]
  },
  {
    text: 'Advanced',
    collapsed: true,
    items: [
      { text: 'Shared Instance', link: '/advanced/shared-instance' },
      { text: 'Commit Hooks', link: '/advanced/commit-hooks' },
      { text: 'Execution Control', link: '/advanced/execution-control' },
      { text: 'Error Logger', link: '/advanced/logger' }
    ]
  },
  {
    text: 'Architecture',
    collapsed: true,
    items: [
      { text: 'Rollback', link: '/architecture/rollback' },
      { text: 'Registration', link: '/architecture/registration' }
    ]
  }
]

/** Routes each version serves, so the switcher can hold your place across versions. */
const routes = (sidebar, home) => [home, ...sidebar.flatMap((g) => g.items.map((i) => i.link))]
const pages = { [latest]: routes(current, '/'), '3.1.0': routes(v310, '/3.1.0/') }
const versions = ['3.1.0']

export default withMermaid({
  cleanUrls: true,
  lang: 'en-US',
  title: siteTitle,
  description: siteDescription,
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['meta', { name: 'author', content: 'Beyond The Cloud' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:site_name', content: siteTitle }],
    ['meta', { property: 'og:image', content: `${siteUrl}/logo.png` }],
    ['meta', { name: 'twitter:card', content: 'summary' }],
    [
      'script',
      { type: 'application/ld+json' },
      JSON.stringify({
        '@context': 'https://schema.org',
        '@type': 'SoftwareApplication',
        name: siteTitle,
        description: siteDescription,
        url: siteUrl,
        applicationCategory: 'DeveloperApplication',
        operatingSystem: 'Salesforce',
        license: 'https://opensource.org/licenses/MIT',
        codeRepository: 'https://github.com/beyond-the-cloud-dev/dml-lib',
        isPartOf: { '@type': 'SoftwareApplication', name: 'Apex Fluently', url: 'https://apexfluently.beyondthecloud.dev' },
        offers: { '@type': 'Offer', price: '0', priceCurrency: 'USD' },
        author: {
          '@type': 'Organization',
          name: 'Beyond The Cloud',
          url: 'https://beyondthecloud.dev',
          sameAs: ['https://github.com/beyond-the-cloud-dev', 'https://www.linkedin.com/company/beyondtheclouddev']
        }
      })
    ],
    [
      'script',
      { async: '', src: 'https://www.googletagmanager.com/gtag/js?id=G-8DMDH217B8' }
    ],
    [
      'script',
      {},
      `window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-8DMDH217B8');`
    ]
  ],
  sitemap: {
    hostname: siteUrl
  },
  vite: {
    plugins: [llmstxt({ domain: siteUrl, ignoreFiles: ['versions/**/*'] })]
  },
  // Serve website/versions/<version>/**  at  /<version>/**
  rewrites: { 'versions/:version/:rest*': ':version/:rest*' },
  transformPageData(pageData) {
    let canonicalUrl = `${siteUrl}/${pageData.relativePath}`
      .replace(/index\.md$/, '')
      .replace(/\.md$/, '')
      .replace(/\/$/, '')
    pageData.frontmatter.head ??= []
    pageData.frontmatter.head.push(
      ['link', { rel: 'canonical', href: canonicalUrl || siteUrl }],
      ['meta', { property: 'og:url', content: canonicalUrl || siteUrl }]
    )
    const pageTitle = pageData.frontmatter.title || pageData.title
    pageData.frontmatter.head.push(
      ['meta', { property: 'og:title', content: pageTitle && pageTitle !== siteTitle ? `${pageTitle} | ${siteTitle}` : siteTitle }],
      ['meta', { property: 'og:description', content: pageData.frontmatter.description || pageData.description || siteDescription }]
    )
    // Keep archived versions out of search engines; they stay reachable via the switcher.
    if (pageData.relativePath.startsWith('versions/')) {
      pageData.frontmatter.head.push(['meta', { name: 'robots', content: 'noindex, follow' }])
    }
  },
  themeConfig: {
    logo: '/logo.png',
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { component: 'VersionedNavLink', props: { text: 'Home', link: '/', versions } },
      { component: 'VersionedNavLink', props: { text: 'Documentation', link: '/introduction', versions } },
      { component: 'VersionSwitcher', props: { latest, versions, pages } }
    ],
    search: {
      provider: 'local',
      options: {
        // Keep archived versions out of the search index, so results are not a
        // mix of current and superseded docs. VitePress calls this "faceting";
        // it has no built-in support yet.
        _render(src, env, md) {
          if (env.relativePath.startsWith('versions/')) return ''
          const html = md.render(src, env)
          return env.frontmatter?.search === false ? '' : html
        }
      }
    },
    sidebar: { '/3.1.0/': v310, '/': current },
    footer: false,
    socialLinks: [
      { icon: 'github', link: 'https://github.com/beyond-the-cloud-dev/dml-lib' },
      {
        icon: 'linkedin',
        link: 'https://www.linkedin.com/company/beyondtheclouddev'
      }
    ]
  }
})
