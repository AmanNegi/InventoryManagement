import _ from 'lodash'
import toast from 'react-hot-toast'

import { BillingDetails } from '../presentation/Bill'
import InventoryItem from './item'

export default class HomeAPI {
  async getItems(): Promise<InventoryItem[]> {
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL}/list/getAll`)
      console.log(res)
      const data = await res.json()
      if (res.status !== 200) {
        toast.error('An error occurred', { icon: '🥲' })
      }
      return data as InventoryItem[]
    } catch (e) {
      toast.error('An error occurred', { icon: '🥲' })
      console.log('An error occurred', e)
      return []
    }
  }

  async addItem({
    title,
    description,
    images,
    costPrice,
    sellingPrice,
    quantity
  }: {
    title: string
    description: string
    images: string[]
    costPrice: number
    sellingPrice: number
    quantity: number
  }): Promise<unknown> {
    return fetch(`${import.meta.env.VITE_API_URL}/list/addItem`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        title,
        description,
        images,
        costPrice,
        sellingPrice,
        quantity
      })
    })
      .then((response) => response.json())
      .then((data) => data)
  }

  async updateItem({
    id,
    title,
    description,
    images,
    price,
    quantity
  }: {
    id: string
    title: string
    description: string
    images: string[]
    price: number
    quantity: number
  }): Promise<unknown> {
    const res = await fetch(
      `${import.meta.env.VITE_API_URL}/list/updateItem/${id}`,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          title,
          description,
          images,
          price,
          quantity
        })
      }
    )

    if (res.status !== 200) {
      const data = await res.text()
      console.log(data)
      toast.error(data, { icon: '🥲' })
      return null
    }

    const data = await res.json()
    toast.success('Item updated successfully', { icon: '🥳' })
    return data
  }

  async deleteItem(itemId: string) {
    const res = await fetch(
      `${import.meta.env.VITE_API_URL}/list/deleteItem/${itemId}`,
      {
        method: 'DELETE'
      }
    )
    if (res.status !== 200) {
      const data = await res.text()
      console.log(data)
      toast.error(data, { icon: '🥲' })
      return null
    }
    const data = await res.json()
    toast.success('Item deleted successfully', { icon: '🥳' })
    return data
  }

  async placeOrder(bill: BillingDetails): Promise<unknown> {
    try {
      const res = await fetch(
        `${import.meta.env.VITE_API_URL}/transactions/add`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(_.omit(bill, ['_id']))
        }
      )
      if (res.status !== 200) {
        const data = await res.text()
        console.log(data)
        toast.error(data, { icon: '🥲' })
        return undefined
      }
      const data = await res.json()
      return data
    } catch (e) {
      console.log('An error occurred', e)
      toast.error(`An unexpected error occured while checking out! Try again`, {
        icon: '🥲'
      })
      return undefined
    }
  }

  async getTransactions(): Promise<TransactionResponse[]> {
    const res = await fetch(`${import.meta.env.VITE_API_URL}/transactions/all`)
    const data = await res.json()
    return data ?? []
  }

  async getLast30DaysStats(): Promise<StatsData[]> {
    const res = await fetch(
      `${import.meta.env.VITE_API_URL}/transactions/stats/last30Days`
    )
    const data = await res.json()
    return data ?? []
  }
}

export type StatsData = {
  date: Date
  count: number
  totalAmount: number
  totalItemsSold: number
}

export type TransactionResponse = {
  _id: string
  datedAt: Date
} & BillingDetails
