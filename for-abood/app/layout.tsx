import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import { Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'
import 'nextra-theme-docs/style.css'
import type { Metadata } from 'next'
import { Roboto_Mono } from 'next/font/google'
import type { ReactNode } from 'react'

const robotoMono = Roboto_Mono({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
})

export const metadata: Metadata = {
  title: 'LLM Generated References',
  description: 'LLM Generated References',
}

export default async function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <Head>
        <style>{`code, pre code, pre { font-family: ${robotoMono.style.fontFamily} !important; }`}</style>
      </Head>
      <body>
        <Layout
          navbar={<Navbar logo={<span>LLM Generated References</span>} />}
          pageMap={await getPageMap()}
          footer={<Footer>LLM Generated References</Footer>}
        >
          {children}
        </Layout>
      </body>
    </html>
  )
}
