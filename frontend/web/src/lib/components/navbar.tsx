import {
  BadgeIndianRupee,
  BadgePlus,
  LogOut,
  ReceiptText,
  Store,
  UserIcon
} from 'lucide-react'

import appState from '../utils/LocalStorage'

const NavBar = () => {
  return (
    <>
      <section className="fixed top-0 flex h-[60px] w-[100vw] flex-row bg-gray-100 z-[999]">
        <NavBarLink link="/home" title="Inventory">
          <Store />
        </NavBarLink>
        {/* <NavBarLink link="/auth" title="Auth" /> */}
        <NavBarLink link="/add" title="Add">
          <BadgePlus />
        </NavBarLink>
        <NavBarLink link="/bill" title="Bill">
          <ReceiptText />
        </NavBarLink>
        <NavBarLink link="/transactions" title="Transactions">
          <BadgeIndianRupee />
        </NavBarLink>
        <NavBarLink link="/profile" title="Profile">
          <UserIcon />
        </NavBarLink>
        <div className="flex-1"></div>
        <div
          onClick={() => {
            appState.logOutUser()
            window.location.href = '/'
          }}
          className="w-[10vw] hover:bg-gray-200 flex items-center justify-center"
        >
          <LogOut />
        </div>
      </section>
    </>
  )
}

const NavBarLink = ({
  link,
  title,
  children: mobileChildren
}: {
  link: string
  title: string
  children?: React.ReactNode
}) => {
  return (
    <a
      className="flex h-full w-[10vw] md:w-[10vw] items-center justify-center hover:bg-gray-200"
      href={link}
    >
      <p className="hidden md:flex">{title}</p>
      <p className="md:hidden flex">{mobileChildren}</p>
    </a>
  )
}

export default NavBar
