import { useEffect, useState } from 'react'
import toast from 'react-hot-toast'

import appState from '@/lib/utils/LocalStorage'

import { BillingDetails } from '../Bill'

const ContinueBillDialog = ({
  details,
  setBillingDetail
}: {
  details: BillingDetails[]
  setBillingDetail: (details: BillingDetails) => void
}) => {
  const [selectedBill, setSelectedBill] = useState<BillingDetails | undefined>()

  useEffect(() => {
    if (appState.getBillingData().length > 0) {
      const dialog = document.getElementById('billing_data_dialog')
      console.log(dialog)
      if (dialog instanceof HTMLDialogElement) dialog.showModal()
    }
    if (details.length > 0) {
      setSelectedBill(details[0])
    }
  }, [])

  return (
    <>
      <dialog id="billing_data_dialog" className="modal">
        <div className="modal-box">
          <h3 className="text-lg font-bold">Previous Billlings</h3>
          <p className="py-4">Resume billings you decided to postpone... </p>
          <select
            className="select select-bordered w-full max-w-xs"
            onChange={(e) => {
              console.log('Setting Billing Detail: ', e.target.value)
              if (e.target.value) {
                const item = details.find(
                  (detail) => detail._id === e.target.value
                )
                setSelectedBill(item)
              }
            }}
          >
            <option disabled defaultValue="">
              Select a billing
            </option>
            {details.map((detail) => (
              <option key={detail._id}>{detail._id}</option>
            ))}
          </select>

          <div className="modal-action">
            <form method="dialog">
              {/* if there is a button in form, it will close the modal */}
              <button className="mr-2 btn">Close</button>
              <button
                onClick={() => {
                  appState.clearBillingData()
                }}
                className="mr-2 btn btn-warning"
              >
                Clear All
              </button>

              <button
                onClick={async () => {
                  if (selectedBill) setBillingDetail(selectedBill)
                  else toast.error('Please select a billing to resume')
                }}
                className="text-white btn-success btn"
              >
                Resume
              </button>
            </form>
          </div>
        </div>
      </dialog>
    </>
  )
}

export default ContinueBillDialog
