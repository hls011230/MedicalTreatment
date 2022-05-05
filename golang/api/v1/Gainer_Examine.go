package v1

import (
	"A11Smile/db"
	"A11Smile/db/model"
	"A11Smile/eth"
	"context"
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"log"
	"math/big"
)

func Gainer_Examine(gid int,examine *model.PostExamine) error {
	DB := db.Get()
	var w model.Wallet
	DB.Table("gainers").First(&w,"id = ?",gid)

	nonce, err := eth.Client.PendingNonceAt(context.Background(), common.HexToAddress(w.BlockAddress))
	if err != nil {
		log.Fatal(err)
		return err
	}

	fmt.Print(w)
	privateKey, err := crypto.HexToECDSA(w.PrivateKey)
	if err != nil {
		log.Fatal(err)
		return err
	}

	auth, err := bind.NewKeyedTransactorWithChainID(privateKey,eth.ChainID)
	if err != nil {
		log.Fatal(err)
		return err
	}


	auth.GasPrice = eth.GasPrice
	auth.GasLimit = uint64(3000000)
	auth.Nonce = big.NewInt(int64(nonce))

	_,err = eth.Ins.GainerWhether(auth,common.HexToHash(examine.Certificate),examine.MedicalName,examine.Whether,common.HexToAddress(examine.Address),big.NewInt(int64(examine.Ercnum)))
	if err != nil {
		return err
	}
	return nil
}