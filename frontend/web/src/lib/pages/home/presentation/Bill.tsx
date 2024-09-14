import { PanelLeftClose, Trash2 } from 'lucide-react'
import React, { useEffect, useState } from 'react'
import toast from 'react-hot-toast'

import LoadingWidget from '@/lib/components/LoadingWidget'
import appState from '@/lib/utils/LocalStorage'

import HomeAPI from '../application/home_apis'
import InventoryItem from '../application/item'
import CheckoutDialog from './components/CheckoutDialog'
import ContinueBillDialog from './components/ContinueBillDialog'

export type BillingDetails = {
  _id: string
  items: BillingItem[]
  totalAmount: number
  buyerName: string
  biller: string
}

type BillingItem = {
  itemTitle: string
  itemId: string
  quantity: number
  price: number
}

const Bill = () => {
  const userNameRef = React.useRef<HTMLInputElement>(null)
  const quantityRef = React.useRef<HTMLInputElement>(null)

  const nameRef = React.useRef<HTMLSelectElement>(null)
  const idRef = React.useRef<HTMLSelectElement>(null)

  const [isLoading, setIsLoading] = React.useState<boolean>(true)
  const [items, setItems] = React.useState<InventoryItem[]>([])
  const [billItems, setBillItems] = React.useState<BillingDetails>({
    _id: Date.now().toString(),
    items: [],
    totalAmount: 0,
    biller: appState.getUserData().name ?? '',
    buyerName: ''
  })

  const [selectedItem, setSelectedItem] = React.useState<InventoryItem | null>(
    null
  )

  useEffect(() => {
    if (selectedItem && quantityRef.current) {
      quantityRef.current.focus()
    }
  }, [selectedItem])

  useEffect(() => {
    if (userNameRef.current) {
      userNameRef.current.focus()
    }

    const homeAPI = new HomeAPI()
    homeAPI.getItems().then((data) => {
      setItems(data.filter((item) => item.quantity > 0))
      setIsLoading(false)
    })
  }, [])

  function removeItemFromBill(item: BillingItem) {
    setBillItems({
      _id: billItems._id,
      items: billItems.items.filter((i) => i.itemId !== item.itemId),
      totalAmount: billItems.totalAmount - item.price * item.quantity,
      buyerName: billItems.buyerName,
      biller: billItems.biller
    })
    if (nameRef.current) nameRef.current.focus()
  }

  function resetBill() {
    setBillItems({
      _id: Date.now().toString(),
      items: [],
      totalAmount: 0,
      buyerName: '',
      biller: appState.getUserData().name ?? ''
    })
  }

  function addItemToBill() {
    if (selectedItem === null) {
      toast.error('Please select an item', { icon: '🚫' })
      return
    }

    if (!quantityRef.current?.value) {
      toast.error('Enter a valid quantity', { icon: '🚫' })
      return
    }

    if (billItems.items.find((item) => item.itemId === selectedItem._id)) {
      toast.error('Item already added', { icon: '🚫' })
      return
    }

    const quantity = parseInt(quantityRef.current.value) ?? 1
    if (quantity > selectedItem.quantity) {
      toast.error(
        `Can't add more than available quantity.\nAvailable: ${selectedItem.quantity}`,
        {
          icon: '🚫'
        }
      )
      return
    }

    setBillItems({
      _id: billItems._id,
      items: [
        ...billItems.items,
        {
          itemId: selectedItem._id,
          itemTitle: selectedItem.title,
          price: selectedItem.sellingPrice,
          quantity: quantity
        }
      ],
      totalAmount: billItems.totalAmount + selectedItem.sellingPrice * quantity,
      biller: billItems.biller,
      buyerName: userNameRef.current?.value ?? 'No-name'
    })
    setSelectedItem(null)
    quantityRef.current.value = ''
    if (nameRef.current) nameRef.current?.focus()
  }

  if (isLoading) {
    return <LoadingWidget />
  }

  return (
    <>
      <div className="drawer drawer-end lg:drawer-open relative">
        <ContinueBillDialog
          details={appState.getBillingData()}
          setBillingDetail={setBillItems}
        />
        <input id="my-drawer-4" type="checkbox" className="drawer-toggle" />
        <div className="drawer-content">
          {/* Page content here */}
          <section className="px-6 md:px-20 py-10">
            <div className="h-[6vh]"></div>
            <h1 className="mb-4 text-3xl">Create Bill</h1>

            <div className="flex flex-col md:flex-row gap-2 ">
              <label className="flex items-center gap-2 input-bordered input">
                <input
                  className="grow"
                  id="email"
                  ref={userNameRef}
                  placeholder="Name"
                  autoCapitalize="none"
                  autoComplete="email"
                  autoCorrect="off"
                  disabled={isLoading}
                />
              </label>

              <select
                ref={nameRef}
                value={selectedItem !== null ? selectedItem.title : ''}
                className="flex-1 w-full max-w-xs select-bordered select"
                onChange={(e) => {
                  console.log(e.target.value, items)
                  const item = items.find(
                    (item) => item.title === e.target.value
                  )
                  if (!item) return
                  setSelectedItem(item)
                }}
              >
                <option disabled value="">
                  Select Product By Name
                </option>
                {items.map((item) => {
                  return <option key={item._id}>{item.title}</option>
                })}
              </select>
              <select
                ref={idRef}
                value={selectedItem !== null ? selectedItem._id : ''}
                className="flex-1 w-full max-w-xs select-bordered select"
                onChange={(e) => {
                  const item = items.find((item) => item._id === e.target.value)
                  if (!item) return
                  setSelectedItem(item)
                }}
              >
                <option disabled value="">
                  Select Product By ID
                </option>
                {items.map((item) => {
                  return <option key={item._id}>{item._id}</option>
                })}
              </select>
              <label className="flex items-center gap-2 input-bordered input">
                <input
                  className="grow"
                  id="email"
                  ref={quantityRef}
                  placeholder="1"
                  type="number"
                  autoCapitalize="none"
                  autoCorrect="off"
                  disabled={isLoading}
                />
              </label>

              <div className="flex-1"></div>
              <button className="btn-primary btn" onClick={addItemToBill}>
                Add Item
              </button>
            </div>
            <BillTableComponent
              details={billItems}
              removeItemFromBill={removeItemFromBill}
            />
            <div className="fixed inset-x-0 bottom-0 z-10 bg-slate-50 flex h-[10vh] w-full flex-row items-center border-t-2 px-10">
              <h2 className="text-2xl font-bold">
                Total Price: {billItems.totalAmount.toFixed(2)}
              </h2>
              <div className="flex-1"></div>
              <button
                className="btn btn-primary mr-2"
                onClick={() => {
                  if (billItems.items.length > 0) {
                    appState.saveBillingData(billItems)
                    toast.success('Bill Saved', { icon: '🚀' })
                    resetBill()
                  }
                }}
              >
                Save Progress
              </button>
              <CheckoutDialog details={billItems} resetBill={resetBill} />
            </div>
          </section>
          {/* Drawer Logic */}
          <label
            htmlFor="my-drawer-4"
            className="absolute right-0 top-2 drawer-button btn btn-primary lg:hidden"
          >
            <PanelLeftClose />
          </label>
        </div>
        <div className="drawer-side">
          <label
            htmlFor="my-drawer-4"
            aria-label="close sidebar"
            className="drawer-overlay"
          ></label>
          <ul className="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
            {/* Sidebar content here */}
            {/* <li>
              <a>Sidebar Item 1</a>
            </li>
            <li>
              <a>Sidebar Item 2</a>
            </li> */}
            <SearchComponent items={items} addItemToBill={setSelectedItem} />
          </ul>
        </div>
      </div>
    </>
  )
}

const SearchComponent = ({
  items,
  addItemToBill: setSelectedItem
}: {
  items: InventoryItem[]
  addItemToBill: (item: InventoryItem) => void
}) => {
  const [results, setResults] = useState<InventoryItem[]>(items)

  return (
    <>
      <section>
        <div className="h-[6vh]"></div>
        <p>Enter the product name:</p>
        <label className="flex items-center gap-2 input-bordered input mt-2">
          <input
            type="text"
            placeholder="Search.."
            onChange={(e) => {
              if (e.target === undefined || e.target.value === '') {
                return setResults([])
              }
              const res = items.filter((item) =>
                item.title.toLowerCase().trim().includes(e.target.value)
              )
              setResults(res)
            }}
          />
        </label>
        {/* Render results */}
        <div className="flex flex-col gap-2 mt-6">
          {results.map((e) => {
            return (
              <div
                onClick={() => {
                  setSelectedItem(e)
                }}
                key={e._id}
                className="flex flex-row gap-2 hover:bg-gray-50"
              >
                {e.images.length == 0 && (
                  <div className="h-[30px] w-[30px] rounded-full bg-gray-300 center">
                    <h1>{e.title[0]}</h1>
                  </div>
                )}
                {e.images.length > 0 && (
                  <img
                    className="h-[30px] w-[30px] object-cover rounded-full"
                    src={e.images[0]}
                  ></img>
                )}

                <div className="flex flex-col">
                  <p>{e.title}</p>
                  <p>Qty:{e.quantity}</p>
                </div>
                <div className="flex flex-1 "></div>
                <p className="flex text-center items-center justify-center bg-blue-500 text-white px-2 max-h-[6vh] rounded font-bold">
                  ₹ {e.sellingPrice}
                </p>
              </div>
            )
          })}
        </div>
      </section>
    </>
  )
}

const BillTableComponent = ({
  details,
  removeItemFromBill
}: {
  details: BillingDetails
  removeItemFromBill: (item: BillingItem) => void
}) => {
  return (
    <>
      <div className="p-2 my-10 overflow-x-auto border border-dashed">
        <div className="overflow-x-auto">
          <table className="table">
            {/* head */}
            <thead>
              <tr>
                <th></th>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Total</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {details.items.map((item, index) => {
                return (
                  <tr key={item.itemId + index}>
                    <th>{index + 1}</th>
                    <td>{item.itemTitle}</td>
                    <td>{item.quantity}</td>
                    <td>{item.price.toFixed(2)}</td>
                    <td>{(item.price * item.quantity).toFixed(2)}</td>
                    <td>
                      <button
                        className="text-white btn-error btn"
                        onClick={() => removeItemFromBill(item)}
                      >
                        <Trash2 />
                      </button>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      </div>
    </>
  )
}

export default Bill
