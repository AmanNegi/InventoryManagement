import './StatusSticker.css'

import { RefreshCcw } from 'lucide-react'
import React, { useEffect } from 'react'

export default function StatusSticker() {
  const [isOnline, setIsOnline] = React.useState(false)

  async function testFetch() {
    Promise.race([
      fetch(`${import.meta.env.VITE_API_URL}/list/getAll`),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error('timeout')), 5000)
      )
    ])
      .then(() => {
        setIsOnline(true)
      })
      .catch((error) => {
        console.error(error)
        setIsOnline(false)
      })
  }

  useEffect(() => {
    testFetch()
  })

  return (
    <section className="fixed bottom-0 left-1/2 transform -translate-x-1/2 h-[5vh] px-8 bg-black rounded-tl-lg rounded-tr-lg flex items-center justify-center">
      {isOnline ? (
        <>
          <span className="flex w-3 h-3 me-3 bg-green-500 rounded-full"></span>
          <h1 className="text-white">Server Online</h1>
        </>
      ) : (
        <>
          <span className="flex w-3 h-3 me-3 bg-red-500 rounded-full"></span>
          <h1 className="text-white">Server Offline</h1>
          <RefreshCcw
            className="text-white ml-2 bg-green-900 cursor-pointer rounded-full p-1"
            onClick={() => {
              testFetch()
              alert('Refreshing.. Await for minimum of 2 minutes!')
            }}
          />
        </>
      )}
    </section>
  )
}
