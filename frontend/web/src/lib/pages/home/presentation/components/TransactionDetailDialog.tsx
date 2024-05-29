import { BadgeInfo } from 'lucide-react'

import { TransactionResponse } from '../../application/home_apis'

const TransactionDetailDialog = ({
  details
}: {
  details: TransactionResponse
}) => {
  return (
    <>
      <td
        onClick={() => {
          const dialog = document.getElementById(
            'transaction_detail_modal' + details._id
          )
          if (dialog instanceof HTMLDialogElement) dialog.showModal()
        }}
        className="hover:text-yellow-600"
      >
        <BadgeInfo />
      </td>

      <dialog id={'transaction_detail_modal' + details._id} className="modal">
        <div className="modal-box">
          <h3 className="text-lg font-bold">Order Details</h3>
          <p className="py-4">
            Here are the sub-items present in the transaction. With the total
            amount:
            <strong>{' ₹' + details.totalAmount.toFixed(2)}</strong>
          </p>

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
                      <td>{'₹ ' + item.price.toFixed(2)}</td>
                      <td>{'₹ ' + (item.price * item.quantity).toFixed(2)}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>

          <div className="modal-action">
            <form method="dialog">
              <button className="mr-2 btn">Close</button>
            </form>
          </div>
        </div>
      </dialog>
    </>
  )
}

export default TransactionDetailDialog
