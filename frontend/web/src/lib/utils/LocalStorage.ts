import { BillingDetails } from '../pages/home/presentation/Bill'

const APP_STATE_KEY = 'InventoryMgmt-AppState'

type UserData = {
  _id: undefined | string
  createdAt: undefined | string
  email: undefined | string
  name: undefined | string
  phone: undefined | string
  userType: undefined | string
}

class AppState {
  userData: UserData = {
    createdAt: undefined,
    email: undefined,
    name: undefined,
    phone: undefined,
    userType: undefined,
    _id: undefined
  }

  isLoggedIn = false

  __init__() {
    console.log('In __init__ AppState.js...')
    const data = JSON.parse(localStorage.getItem(APP_STATE_KEY) ?? '{}')
    console.log('Local AppState Data: ', data)
    this.userData = data.userData ?? {}
    this.isLoggedIn = data.isLoggedIn ?? false
  }

  saveUserData(userData: UserData, isLoggedIn: boolean) {
    this.userData = userData
    this.isLoggedIn = isLoggedIn
    localStorage.setItem(
      APP_STATE_KEY,
      JSON.stringify({ userData, isLoggedIn })
    )
  }

  clearBillingData() {
    localStorage.removeItem('billingData')
  }

  saveBillingData(billingData: BillingDetails) {
    let data: BillingDetails[] = JSON.parse(
      localStorage.getItem('billingData') || '{"data": []}'
    ).data

    console.log(data)

    if (data) {
      // append a new entry
      data = [...data, billingData]
      localStorage.setItem('billingData', JSON.stringify({ data: [...data] }))
      return
    }

    localStorage.setItem('billingData', JSON.stringify({ data: [billingData] }))
  }

  getBillingData(): BillingDetails[] {
    if (!localStorage.getItem('billingData')) {
      return []
    }

    console.log(
      'billing details' +
        JSON.parse(localStorage.getItem('billingData') || '{data: []}')
    )
    return JSON.parse(localStorage.getItem('billingData') || '{data: []}').data
  }

  logOutUser() {
    this.saveUserData(
      {
        createdAt: undefined,
        email: undefined,
        name: undefined,
        phone: undefined,
        userType: undefined,
        _id: undefined
      },
      false
    )
  }

  isUserLoggedIn() {
    return this.isLoggedIn
  }

  getUserData() {
    return { ...this.userData }
  }

  isAdmin() {
    return this.userData.userType === 'admin'
  }

  setUserData(data: UserData) {
    this.saveUserData(data, this.isLoggedIn)
  }
}

/// Singleton instance for AppState
const appState = new AppState()
export default appState
