import 'index.css'

import { createRoot } from 'react-dom/client'
import { Toaster } from 'react-hot-toast'
import { RouterProvider } from 'react-router-dom'

import StatusSticker from './lib/components/StatusSticker'
import router from './lib/routes'
import appState from './lib/utils/LocalStorage'

appState.__init__()

const container = document.getElementById('root') as HTMLDivElement
const root = createRoot(container)

root.render(
  <>
    <main className="box-border h-[100%] w-[100%] overflow-hidden scroll-smooth ">
      <RouterProvider router={router} />
      <Toaster />
    </main>
  </>
)
