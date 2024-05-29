import { Trash2 } from 'lucide-react'
import React, { useEffect } from 'react'
import toast from 'react-hot-toast'

import HomeAPI from '../../application/home_apis'
import InventoryItem from '../../application/item'

const EditItemDialog = ({ item }: { item: InventoryItem }) => {
  const nameRef = React.useRef<HTMLInputElement>(null)
  const priceRef = React.useRef<HTMLInputElement>(null)
  const quantityRef = React.useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (nameRef.current && priceRef.current && quantityRef.current) {
      nameRef.current.value = item.title
      priceRef.current.value = item.sellingPrice.toString()
      quantityRef.current.value = item.quantity.toString()
    }
  }, [item.sellingPrice, item.quantity, item.title])

  return (
    <>
      <div key={item._id} className="flex flex-row justify-end mx-2 my-2 gap-2">
        <button
          onClick={() => {
            console.log('Delete', item)
            const homeAPI = new HomeAPI()
            homeAPI.deleteItem(item._id)
          }}
          className="btn btn-error text-white"
        >
          <Trash2 />
        </button>
        <button
          className=" text-white 2 btn btn-neutral "
          onClick={() => {
            const dialog = document.getElementById(
              `edit_item_dialog${item._id}`
            )
            if (dialog instanceof HTMLDialogElement) dialog.showModal()
          }}
        >
          Edit
        </button>
      </div>

      <dialog id={'edit_item_dialog' + item._id} className="modal">
        <div className="modal-box">
          <h3 className="mb-4 text-lg font-bold">Edit Item</h3>

          <input
            className="w-full mb-3 input input-bordered"
            ref={nameRef}
          ></input>

          <input
            className="w-full mb-3 input input-bordered"
            type="number"
            ref={priceRef}
          ></input>

          <input
            className="w-full mb-3 input input-bordered"
            type="number"
            ref={quantityRef}
          ></input>

          <div className="modal-action">
            <form method="dialog">
              {/* if there is a button in form, it will close the modal */}
              <button className="mr-2 btn">Close</button>

              <button
                onClick={async () => {
                  if (
                    !nameRef.current ||
                    !priceRef.current ||
                    !quantityRef.current ||
                    nameRef.current.value.trim() === '' ||
                    priceRef.current.value.trim() === '' ||
                    quantityRef.current.value.trim() === ''
                  ) {
                    toast.error('Please fill all fields', { icon: '🥲' })
                    return
                  }

                  const homeAPI = new HomeAPI()
                  await homeAPI.updateItem({
                    id: item._id,
                    title: nameRef.current?.value.trim(),
                    description: item.description.trim(),
                    images: item.images,
                    price: parseFloat(priceRef.current?.value),
                    quantity: parseInt(quantityRef.current?.value)
                  })

                  document.location.href = '/home'
                }}
                className="text-white btn-success btn"
              >
                Update
              </button>
            </form>
          </div>
        </div>
      </dialog>
    </>
  )
}

export default EditItemDialog
