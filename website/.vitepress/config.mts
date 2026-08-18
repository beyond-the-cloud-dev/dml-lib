import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'
import llmstxt from 'vitepress-plugin-llms'
// https://vitepress.dev/reference/site-config

const siteUrl = 'https://dml.beyondthecloud.dev'
const siteTitle = 'DML Lib'
const siteDescription = 'Open-source Apex library for Salesforce DML operations. Fluent API for insert, update, upsert, delete, undelete and publish, with relationship handling, FLS and sharing control, and DML mocking in unit tests. Free, MIT licensed, part of Apex Fluently by Beyond The Cloud.'

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
    plugins: [llmstxt({ domain: siteUrl })]
  },
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
  },
  themeConfig: {
    logo: '/logo.png',
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Documentation', link: '/introduction' }
    ],
    search: {
      provider: 'local'
    },
    sidebar: [
      {
        text: 'Docs',
        items: [
          { text: 'Introduction', link: '/introduction' },
          { text: 'Installation', link: '/installation' }
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
          { text: 'DmlOptions', link: '/configuration/dml-options' }
        ]
      },
      {
        text: 'Advanced',
        collapsed: true,
        items: [
          { text: 'Shared Instance', link: '/advanced/shared-instance' },
          { text: 'Commit Hooks', link: '/advanced/commit-hooks' },
          { text: 'Execution Control', link: '/advanced/execution-control' }
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
    ],
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
