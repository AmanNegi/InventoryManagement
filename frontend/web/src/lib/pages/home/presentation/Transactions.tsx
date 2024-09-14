import { useEffect, useState } from 'react'

import HomeAPI, { TransactionResponse } from '../application/home_apis'
import TransactionDetailDialog from './components/TransactionDetailDialog'

const Transactions = () => {
  const [transactionsRes, setTransactionsRes] = useState<
    TransactionResponse[] | null
  >(null)

  useEffect(() => {
    const homeAPI = new HomeAPI()
    homeAPI.getTransactions().then((v) => {
      setTransactionsRes(v)
    })
  }, [])

  return (
    <section className="px-8 md:px-10 lg:px-20 py-10">
      <div className="h-[6vh]"></div>
      <h1 className="mb-4 text-3xl">Transactions</h1>
      {transactionsRes && <TableComponent details={transactionsRes} />}
    </section>
  )
}
const TableComponent = ({ details }: { details: TransactionResponse[] }) => {
  return (
    <>
      <div className="p-2 my-10 overflow-x-auto border border-dashed">
        <div className="overflow-x-auto">
          <table className="table">
            {/* head */}
            <thead>
              <tr>
                <th></th>
                <th>Buyer</th>
                <th>Items</th>
                <th>Biller</th>
                <th>Total Amount</th>
                <th>Dated</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {details.map((item, index) => {
                return (
                  <tr className="hover" key={item._id + index}>
                    <th>{index + 1}</th>
                    <td>{item.buyerName}</td>
                    <td>{item.items.length}</td>
                    <td>{item.biller}</td>
                    <td>{'₹ ' + item.totalAmount.toFixed(2)}</td>
                    <td>
                      {new Date(item.datedAt).toLocaleString('en-GB', {
                        day: '2-digit',
                        month: '2-digit',
                        year: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false
                      })}
                    </td>
                    <TransactionDetailDialog details={item} />
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

export default Transactions
