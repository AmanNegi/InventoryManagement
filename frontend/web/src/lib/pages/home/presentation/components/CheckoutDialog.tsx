import toast from 'react-hot-toast'

import HomeAPI from '../../application/home_apis'
import { BillingDetails } from '../Bill'

const CheckoutDialog = ({
  details,
  resetBill
}: {
  details: BillingDetails
  resetBill: () => void
}) => {
  return (
    <>
      <button
        className="btn-primary btn"
        onClick={() => {
          const dialog = document.getElementById('my_modal_1')
          if (dialog instanceof HTMLDialogElement) dialog.showModal()
        }}
      >
        Checkout
      </button>
      <dialog id="my_modal_1" className="modal">
        <div className="modal-box">
          <h3 className="text-lg font-bold">
            Please confirm the order details
          </h3>
          <p className="py-4">
            The total price of the order is:{' '}
            <strong>{details.totalAmount.toFixed(2)}</strong>
          </p>
          <div className="modal-action">
            <form method="dialog">
              {/* if there is a button in form, it will close the modal */}
              <button className="mr-2 btn">Close</button>

              <button
                onClick={async () => {
                  const homeAPI = new HomeAPI()
                  const res = await homeAPI.placeOrder(details)

                  console.log('Response: ', res)

                  if (res === undefined) {
                    toast.error('Failed to place order!', { icon: '🥲' })
                    return
                  }

                  toast.success('Order confirmed', { icon: '🚀' })
                  resetBill()
                }}
                className="text-white btn-success btn"
              >
                Confirm
              </button>
            </form>
          </div>
        </div>
      </dialog>
    </>
  )
}

export default CheckoutDialog
