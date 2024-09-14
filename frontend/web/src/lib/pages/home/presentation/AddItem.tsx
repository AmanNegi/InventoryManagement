import { FileSpreadsheet } from 'lucide-react'
import Papa from 'papaparse'
import { useEffect } from 'react'
import React from 'react'
import toast from 'react-hot-toast'
import { useNavigate } from 'react-router-dom'

import appState from '@/lib/utils/LocalStorage'

import HomeAPI from '../application/home_apis'

const AddItem = () => {
  const navigate = useNavigate()

  const titleRef = React.useRef<HTMLInputElement>(null)
  const descriptionRef = React.useRef<HTMLTextAreaElement>(null)
  const costPriceRef = React.useRef<HTMLInputElement>(null)
  const sellingPriceRef = React.useRef<HTMLInputElement>(null)
  const quantityRef = React.useRef<HTMLInputElement>(null)

  const [isLoading, setIsLoading] = React.useState<boolean>(false)
  const [csvFile, setCsvFile] = React.useState<File | null>(null)

  useEffect(() => {
    if (!appState.isLoggedIn) {
      navigate('/auth')
    }
  })
  async function onSubmit() {
    const homeAPI = new HomeAPI()
    if (
      !titleRef.current ||
      !descriptionRef.current ||
      !quantityRef.current ||
      !costPriceRef.current ||
      !sellingPriceRef.current
    )
      return

    setIsLoading(true)

    console.log(
      'Adding Item',
      titleRef.current?.value,
      descriptionRef.current?.value
    )

    const res = await homeAPI.addItem({
      title: titleRef.current?.value.trim(),
      description: descriptionRef.current?.value.trim(),
      quantity: parseInt(quantityRef.current?.value || '1'),
      costPrice: parseFloat(costPriceRef.current?.value || '0'),
      sellingPrice: parseFloat(sellingPriceRef.current?.value || '0'),
      images: ['https://via.placeholder.com/150']
    })
    console.log(res)

    setIsLoading(false)
    navigate('/home')
  }
  return (
    <main className="flex flex-col mx-6 md:mx-20 my-10">
      <div className="h-[6vh]"></div>
      <div className="flex flex-col md:flex-row gap-2 md:gap-0">
        <h1 className="text-3xl font-bold">Add Item</h1>
        <div className="flex-1"></div>
        <input
          type="file"
          accept=".csv"
          className="file-input file-input-bordered w-full max-w-xs mr-4"
          onChange={(e) => {
            if (e.target.files && e.target.files.length > 0) {
              console.log(e.target.files[0])
              setCsvFile(e.target.files[0])
            } else {
              toast.error('Please select a file', {
                icon: '🚫'
              })
            }
          }}
        />
        <button
          className="btn btn-outline"
          onClick={async () => {
            if (!csvFile) {
              toast.error('Please select a file', {
                icon: '🚫'
              })
            } else {
              const reader = new FileReader()
              reader.onload = async function (evt) {
                const contents = evt.target?.result
                const result = Papa.parse(contents as string)
                // skip first result, as it contains headers
                const data: string[][] = result.data.slice(1) as string[][]

                const homeAPI = new HomeAPI()

                const promises = data.map((item) => {
                  console.log(item)
                  return homeAPI.addItem({
                    title: item[1],
                    description: item[1],
                    quantity: parseFloat(item[2]),
                    costPrice: parseFloat(item[3]),
                    sellingPrice: parseFloat(item[4]),
                    images: ['https://via.placeholder.com/150']
                  })
                })

                const res = await Promise.all(promises)
                console.log(res)
                toast.success('Items added successfully', { icon: '🎉' })
              }

              reader.readAsText(csvFile)
            }
          }}
        >
          <FileSpreadsheet />
        </button>
      </div>
      <div className="h-[2vh]"></div>
      <label className="flex items-center gap-2 input-bordered input">
        <input
          className="grow"
          id="title"
          ref={titleRef}
          placeholder="Enter your title here"
          disabled={isLoading}
        />
      </label>
      <div className="h-[1vh]"></div>
      <textarea
        ref={descriptionRef}
        className="textarea-bordered textarea"
        placeholder="Description"
      ></textarea>
      <div className="h-[1vh]"></div>
      <label className="flex items-center gap-2 input-bordered input">
        <input
          className="grow"
          id="Price"
          ref={costPriceRef}
          placeholder="Cost Price"
          type="number"
          disabled={isLoading}
        />
      </label>
      <div className="h-[1vh]"></div>
      <label className="flex items-center gap-2 input-bordered input">
        <input
          className="grow"
          id="Price"
          ref={sellingPriceRef}
          placeholder="SelllingPrice"
          type="number"
          disabled={isLoading}
        />
      </label>
      <div className="h-[1vh]"></div>
      <label className="flex items-center gap-2 input-bordered input">
        <input
          className="grow"
          id="quantity"
          ref={quantityRef}
          placeholder="Quantity"
          type="number"
          disabled={isLoading}
        />
      </label>

      <div className="h-[2vh]"></div>
      <button onClick={onSubmit} className="btn-primary btn">
        Add Item
      </button>
    </main>
  )
}

export default AddItem
