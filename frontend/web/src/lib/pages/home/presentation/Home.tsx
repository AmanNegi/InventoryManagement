import React, { useEffect } from 'react'

import LoadingWidget from '@/lib/components/LoadingWidget'

import HomeAPI from '../application/home_apis'
import InventoryItem from '../application/item'
import EditItemDialog from './components/EditItemDialog'

const Home = () => {
  const [isLoading, setIsLoading] = React.useState<boolean>(true)
  const [items, setItems] = React.useState<InventoryItem[]>([])

  useEffect(() => {
    const homeAPI = new HomeAPI()
    homeAPI.getItems().then((data) => {
      console.log(data)
      setItems(data as InventoryItem[])
      setIsLoading(false)
    })
  }, [])

  if (isLoading) return <LoadingWidget />

  return (
    <section className="mx-5 my-10 md:mx-20">
      <div className="h-[6vh]"></div>
      <h1 className="mb-4 text-3xl font-bold">Home</h1>
      <div className="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
        {items.map((item) => {
          return (
            <div
              key={item._id}
              className="border border-gray-200 rounded-md hover:scale-105 transition-all"
            >
              {item.images.length == 0 && (
                <img
                  className="h-[15vh] md:h-[25vh] w-full object-cover rounded-tl-sm rounded-tr-sm"
                  src="https://placehold.co/600x400"
                />
              )}
              {item.images.length > 0 && (
                <img
                  className="h-[15vh] md:h-[25vh] w-full object-cover rounded-tl-sm rounded-tr-sm"
                  src={item.images[0]}
                  alt={item.title}
                />
              )}
              <div className="px-4 py-2">
                <h1>{item.title}</h1>
                <p className="text-gray-500">{item.description}</p>
                <p className="text-gray-500">{item.quantity}</p>
                <p className="font-semibold text-gray-800">
                  ₹ {item.sellingPrice}
                </p>
              </div>

              <EditItemDialog key={item._id} item={item} />
            </div>
          )
        })}
      </div>
    </section>
  )
}

export default Home
